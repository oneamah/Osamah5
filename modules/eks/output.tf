output "cluster_name" {
	description = "EKS cluster name"
	value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
	description = "EKS cluster ARN"
	value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
	description = "EKS cluster API server endpoint"
	value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
	description = "Base64 encoded cluster CA data"
	value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer" {
	description = "OIDC issuer URL for the EKS cluster"
	value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_group_name" {
	description = "EKS managed node group name"
	value       = aws_eks_node_group.this.node_group_name
}

output "node_group_arn" {
	description = "EKS managed node group ARN"
	value       = aws_eks_node_group.this.arn
}
