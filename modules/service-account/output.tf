output "service_account_role_name" {
	description = "IAM role name for Kubernetes service account"
	value       = aws_iam_role.this.name
}

output "service_account_role_arn" {
	description = "IAM role ARN for Kubernetes service account"
	value       = aws_iam_role.this.arn
}

output "oidc_provider_arn" {
	description = "IAM OIDC provider ARN used by IRSA"
	value       = var.create_oidc_provider ? aws_iam_openid_connect_provider.this[0].arn : var.oidc_provider_arn
}
