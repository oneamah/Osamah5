output "eks_cluster_security_group_id" {
	description = "Security group ID for EKS control plane"
	value       = aws_security_group.eks_cluster.id
}

output "eks_cluster_security_group_arn" {
	description = "Security group ARN for EKS control plane"
	value       = aws_security_group.eks_cluster.arn
}

output "eks_node_security_group_id" {
	description = "Security group ID for EKS worker nodes"
	value       = aws_security_group.eks_node.id
}

output "eks_node_security_group_arn" {
	description = "Security group ARN for EKS worker nodes"
	value       = aws_security_group.eks_node.arn
}
