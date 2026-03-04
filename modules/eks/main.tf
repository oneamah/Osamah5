resource "aws_eks_cluster" "this" {
	name     = var.cluster_name
	role_arn = var.eks_cluster_role_arn
	version  = var.cluster_version

	access_config {
		authentication_mode = var.cluster_authentication_mode
	}

	vpc_config {
		subnet_ids              = var.cluster_subnet_ids
		security_group_ids      = [var.cluster_security_group_id]
		endpoint_public_access  = var.endpoint_public_access
		endpoint_private_access = var.endpoint_private_access
		public_access_cidrs     = var.endpoint_public_access_cidrs
	}

	enabled_cluster_log_types = var.enabled_cluster_log_types

	tags = var.tags
}

resource "aws_eks_node_group" "this" {
	cluster_name    = aws_eks_cluster.this.name
	node_group_name = var.node_group_name
	node_role_arn   = var.eks_node_group_role_arn
	subnet_ids      = var.node_subnet_ids
	ami_type        = var.node_ami_type
	capacity_type   = var.node_capacity_type
	instance_types  = var.node_instance_types

	scaling_config {
		desired_size = var.node_desired_size
		min_size     = var.node_min_size
		max_size     = var.node_max_size
	}

	update_config {
		max_unavailable = var.node_max_unavailable
	}

	tags = var.tags

	depends_on = [aws_eks_cluster.this]
}

locals {
	admin_principal_arns = distinct(compact(concat(
		var.create_cluster_admin_access ? [var.cluster_admin_principal_arn] : [],
		var.additional_admin_principal_arns
	)))
}

resource "aws_eks_access_entry" "cluster_admin" {
	for_each = toset(local.admin_principal_arns)

	cluster_name  = aws_eks_cluster.this.name
	principal_arn = each.value
	type          = "STANDARD"

	depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_access_policy_association" "cluster_admin" {
	for_each = toset(local.admin_principal_arns)

	cluster_name  = aws_eks_cluster.this.name
	principal_arn = each.value
	policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

	access_scope {
		type = "cluster"
	}

	depends_on = [aws_eks_access_entry.cluster_admin]
}
