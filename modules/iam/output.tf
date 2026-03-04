output "eks_cluster_role_name" {
	description = "EKS cluster IAM role name"
	value       = aws_iam_role.eks_cluster_role.name
}

output "eks_cluster_role_arn" {
	description = "EKS cluster IAM role ARN"
	value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_name" {
	description = "EKS node group IAM role name"
	value       = aws_iam_role.eks_node_group_role.name
}

output "eks_node_group_role_arn" {
	description = "EKS node group IAM role ARN"
	value       = aws_iam_role.eks_node_group_role.arn
}

output "cluster_admin_user_name" {
	description = "EKS cluster admin IAM username"
	value       = try(aws_iam_user.cluster_admin[0].name, null)
}

output "cluster_admin_user_arn" {
	description = "EKS cluster admin IAM user ARN"
	value       = try(aws_iam_user.cluster_admin[0].arn, null)
}
