resource "aws_security_group" "eks_cluster" {
	name        = var.cluster_security_group_name
	description = "Security group for EKS control plane"
	vpc_id      = var.vpc_id

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = merge(var.tags, {
		Name = var.cluster_security_group_name
	})
}

resource "aws_security_group" "eks_node" {
	name        = var.node_security_group_name
	description = "Security group for EKS worker nodes"
	vpc_id      = var.vpc_id

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = merge(var.tags, {
		Name = var.node_security_group_name
	})
}

resource "aws_security_group_rule" "cluster_ingress_from_nodes_https" {
	type                     = "ingress"
	from_port                = 443
	to_port                  = 443
	protocol                 = "tcp"
	security_group_id        = aws_security_group.eks_cluster.id
	source_security_group_id = aws_security_group.eks_node.id
	description              = "Allow worker nodes to communicate with EKS API server"
}

resource "aws_security_group_rule" "nodes_ingress_from_cluster_ephemeral" {
	type                     = "ingress"
	from_port                = 1025
	to_port                  = 65535
	protocol                 = "tcp"
	security_group_id        = aws_security_group.eks_node.id
	source_security_group_id = aws_security_group.eks_cluster.id
	description              = "Allow control plane to communicate with worker nodes"
}

resource "aws_security_group_rule" "nodes_ingress_self" {
	type              = "ingress"
	from_port         = 0
	to_port           = 65535
	protocol          = "-1"
	security_group_id = aws_security_group.eks_node.id
	self              = true
	description       = "Allow node-to-node communication"
}

resource "aws_security_group_rule" "nodes_ingress_ssh" {
	count             = length(var.allowed_ssh_cidrs) > 0 ? 1 : 0
	type              = "ingress"
	from_port         = 22
	to_port           = 22
	protocol          = "tcp"
	security_group_id = aws_security_group.eks_node.id
	cidr_blocks       = var.allowed_ssh_cidrs
	description       = "Allow SSH access to worker nodes"
}

resource "aws_security_group_rule" "cluster_ingress_from_bastion_https" {
	count                    = var.enable_bastion_rules ? 1 : 0
	type                     = "ingress"
	from_port                = 443
	to_port                  = 443
	protocol                 = "tcp"
	security_group_id        = aws_security_group.eks_cluster.id
	source_security_group_id = var.bastion_security_group_id
	description              = "Allow bastion to communicate with EKS API server"
}

resource "aws_security_group_rule" "nodes_ingress_ssh_from_bastion" {
	count                    = var.enable_bastion_rules ? 1 : 0
	type                     = "ingress"
	from_port                = 22
	to_port                  = 22
	protocol                 = "tcp"
	security_group_id        = aws_security_group.eks_node.id
	source_security_group_id = var.bastion_security_group_id
	description              = "Allow bastion SSH access to EKS worker nodes"
}
