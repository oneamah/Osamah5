data "aws_availability_zones" "available" {
	state = "available"
}

data "aws_partition" "current" {}

data "aws_ami" "bastion" {
	most_recent = true
	owners      = ["amazon"]

	filter {
		name   = "name"
		values = ["amzn2-ami-hvm-*-x86_64-gp2"]
	}

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}
}

locals {
	effective_az_count = min(var.az_count, length(data.aws_availability_zones.available.names))
}

resource "aws_vpc" "this" {
	cidr_block           = var.vpc_cidr
	enable_dns_support   = true
	enable_dns_hostnames = true

	tags = merge(var.tags, {
		Name = "${var.name_prefix}-vpc"
	})
}

resource "aws_internet_gateway" "this" {
	vpc_id = aws_vpc.this.id

	tags = merge(var.tags, {
		Name = "${var.name_prefix}-igw"
	})
}

resource "aws_subnet" "public" {
	count = local.effective_az_count

	vpc_id                  = aws_vpc.this.id
	cidr_block              = var.public_subnet_cidrs[count.index]
	availability_zone       = data.aws_availability_zones.available.names[count.index]
	map_public_ip_on_launch = true

	tags = merge(var.tags, {
		Name                              = "${var.name_prefix}-public-${count.index + 1}"
		"kubernetes.io/role/elb"         = "1"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	})
}

resource "aws_subnet" "private" {
	count = local.effective_az_count

	vpc_id            = aws_vpc.this.id
	cidr_block        = var.private_subnet_cidrs[count.index]
	availability_zone = data.aws_availability_zones.available.names[count.index]

	tags = merge(var.tags, {
		Name                                       = "${var.name_prefix}-private-${count.index + 1}"
		"kubernetes.io/role/internal-elb"         = "1"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
	})
}

resource "aws_eip" "nat" {
	count = var.single_nat_gateway ? 1 : local.effective_az_count

	domain = "vpc"

	tags = merge(var.tags, {
		Name = var.single_nat_gateway ? "${var.name_prefix}-nat-eip" : "${var.name_prefix}-nat-eip-${count.index + 1}"
	})
}

resource "aws_nat_gateway" "this" {
	count = var.single_nat_gateway ? 1 : local.effective_az_count

	allocation_id = aws_eip.nat[count.index].id
	subnet_id     = var.single_nat_gateway ? aws_subnet.public[0].id : aws_subnet.public[count.index].id

	tags = merge(var.tags, {
		Name = var.single_nat_gateway ? "${var.name_prefix}-nat" : "${var.name_prefix}-nat-${count.index + 1}"
	})

	timeouts {
		delete = var.nat_gateway_delete_timeout
	}

	depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.this.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.this.id
	}

	tags = merge(var.tags, {
		Name = "${var.name_prefix}-public-rt"
	})
}

resource "aws_route_table_association" "public" {
	count = local.effective_az_count

	subnet_id      = aws_subnet.public[count.index].id
	route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
	count = var.single_nat_gateway ? 1 : local.effective_az_count

	vpc_id = aws_vpc.this.id

	route {
		cidr_block     = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.this[count.index].id
	}

	tags = merge(var.tags, {
		Name = var.single_nat_gateway ? "${var.name_prefix}-private-rt" : "${var.name_prefix}-private-rt-${count.index + 1}"
	})
}

resource "aws_route_table_association" "private" {
	count = local.effective_az_count

	subnet_id      = aws_subnet.private[count.index].id
	route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}

resource "aws_security_group" "bastion" {
	count = var.create_bastion ? 1 : 0

	name        = var.bastion_security_group_name
	description = "Security group for bastion host"
	vpc_id      = aws_vpc.this.id

	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = var.bastion_allowed_cidrs
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = merge(var.tags, {
		Name = var.bastion_security_group_name
	})
}

resource "aws_iam_role" "bastion_ssm" {
	count = var.create_bastion && var.enable_bastion_ssm ? 1 : 0

	name = "${var.name_prefix}-bastion-ssm-role"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect = "Allow"
				Principal = {
					Service = "ec2.amazonaws.com"
				}
				Action = "sts:AssumeRole"
			}
		]
	})

	tags = var.tags
}

resource "aws_iam_role_policy_attachment" "bastion_ssm_core" {
	count = var.create_bastion && var.enable_bastion_ssm ? 1 : 0

	role       = aws_iam_role.bastion_ssm[0].name
	policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion" {
	count = var.create_bastion && var.enable_bastion_ssm ? 1 : 0

	name = "${var.name_prefix}-bastion-instance-profile"
	role = aws_iam_role.bastion_ssm[0].name

	tags = var.tags
}

resource "aws_instance" "bastion" {
	count = var.create_bastion ? 1 : 0

	ami                         = coalesce(var.bastion_ami_id, data.aws_ami.bastion.id)
	instance_type               = var.bastion_instance_type
	subnet_id                   = aws_subnet.public[0].id
	vpc_security_group_ids      = [aws_security_group.bastion[0].id]
	associate_public_ip_address = true
	key_name                    = var.bastion_key_name
	iam_instance_profile        = var.enable_bastion_ssm ? aws_iam_instance_profile.bastion[0].name : null

	tags = merge(var.tags, {
		Name = var.bastion_name
	})

	depends_on = [
		aws_internet_gateway.this,
		aws_route_table_association.public,
		aws_iam_role_policy_attachment.bastion_ssm_core
	]
}
