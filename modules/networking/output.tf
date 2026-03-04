output "vpc_id" {
	description = "ID of the VPC"
	value       = aws_vpc.this.id
}

output "public_subnet_ids" {
	description = "IDs of public subnets"
	value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
	description = "IDs of private subnets"
	value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
	description = "ID of the internet gateway"
	value       = aws_internet_gateway.this.id
}

output "nat_gateway_ids" {
	description = "IDs of NAT gateways"
	value       = aws_nat_gateway.this[*].id
}

output "bastion_instance_id" {
	description = "Bastion instance ID"
	value       = try(aws_instance.bastion[0].id, null)
}

output "bastion_public_ip" {
	description = "Bastion public IP"
	value       = try(aws_instance.bastion[0].public_ip, null)
}

output "bastion_security_group_id" {
	description = "Bastion security group ID"
	value       = try(aws_security_group.bastion[0].id, null)
}

output "bastion_ssm_role_arn" {
	description = "IAM role ARN used by bastion for Session Manager"
	value       = try(aws_iam_role.bastion_ssm[0].arn, null)
}
