output "eks_cluster_role_name" {
  description = "EKS cluster IAM role name from IAM module"
  value       = module.iam.eks_cluster_role_name
}

output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN from IAM module"
  value       = module.iam.eks_cluster_role_arn
}

output "eks_node_group_role_name" {
  description = "EKS node group IAM role name from IAM module"
  value       = module.iam.eks_node_group_role_name
}

output "eks_node_group_role_arn" {
  description = "EKS node group IAM role ARN from IAM module"
  value       = module.iam.eks_node_group_role_arn
}

output "cluster_admin_user_name" {
  description = "IAM username for EKS cluster admin"
  value       = module.iam.cluster_admin_user_name
}

output "cluster_admin_user_arn" {
  description = "IAM ARN for EKS cluster admin"
  value       = module.iam.cluster_admin_user_arn
}

output "service_account_role_name" {
  description = "IAM role name from service-account module"
  value       = module.service-account.service_account_role_name
}

output "service_account_role_arn" {
  description = "IAM role ARN from service-account module"
  value       = module.service-account.service_account_role_arn
}

output "service_account_oidc_provider_arn" {
  description = "OIDC provider ARN from service-account module"
  value       = module.service-account.oidc_provider_arn
}

output "networking_nat_gateway_ids" {
  description = "NAT gateway IDs from networking module"
  value       = module.networking.nat_gateway_ids
}

output "bastion_instance_id" {
  description = "Bastion instance ID from networking module"
  value       = module.networking.bastion_instance_id
}

output "bastion_public_ip" {
  description = "Bastion public IP from networking module"
  value       = module.networking.bastion_public_ip
}

output "bastion_ssm_role_arn" {
  description = "Bastion Session Manager IAM role ARN"
  value       = module.networking.bastion_ssm_role_arn
}

output "argo_cd_ingress_url" {
  description = "Argo CD ingress URL"
  value       = module.helm.argo_cd_ingress_url
}

output "grafana_ingress_url" {
  description = "Grafana ingress URL"
  value       = module.helm.grafana_ingress_url
}

output "argo_cd_route53_record_fqdn" {
  description = "Route53 FQDN for Argo CD"
  value       = module.helm.argo_cd_route53_record_fqdn
}

output "grafana_route53_record_fqdn" {
  description = "Route53 FQDN for Grafana"
  value       = module.helm.grafana_route53_record_fqdn
}

output "external_dns_release_name" {
  description = "ExternalDNS Helm release name"
  value       = module.helm.external_dns_release_name
}
