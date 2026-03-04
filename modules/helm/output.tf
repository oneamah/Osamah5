output "coredns_addon_arn" {
	description = "CoreDNS addon ARN"
	value       = try(aws_eks_addon.coredns[0].arn, null)
}

output "ingress_nginx_release_name" {
	description = "Ingress NGINX Helm release name"
	value       = try(helm_release.ingress_nginx[0].name, null)
}

output "argo_cd_release_name" {
	description = "Argo CD Helm release name"
	value       = try(helm_release.argo_cd[0].name, null)
}

output "kube_prometheus_stack_release_name" {
	description = "kube-prometheus-stack Helm release name"
	value       = try(helm_release.kube_prometheus_stack[0].name, null)
}

output "external_dns_release_name" {
	description = "ExternalDNS Helm release name"
	value       = try(helm_release.external_dns[0].name, null)
}

output "argo_cd_ingress_url" {
	description = "Argo CD ingress URL"
	value       = var.enable_argo_cd_ingress ? "${var.enable_https ? "https" : "http"}://${var.argo_cd_ingress_host}" : null
}

output "grafana_ingress_url" {
	description = "Grafana ingress URL"
	value       = var.enable_grafana_ingress ? "${var.enable_https ? "https" : "http"}://${var.grafana_ingress_host}" : null
}

output "argo_cd_route53_record_fqdn" {
	description = "Route53 FQDN for Argo CD"
	value       = try(aws_route53_record.argo_cd[0].fqdn, null)
}

output "grafana_route53_record_fqdn" {
	description = "Route53 FQDN for Grafana"
	value       = try(aws_route53_record.grafana[0].fqdn, null)
}
