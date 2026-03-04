variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name to install addons into"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data (base64)"
  type        = string
}

variable "enable_coredns" {
  description = "Enable CoreDNS EKS addon"
  type        = bool
  default     = true
}

variable "coredns_addon_version" {
  description = "Optional CoreDNS addon version"
  type        = string
  default     = null
}

variable "enable_ingress_nginx" {
  description = "Enable ingress-nginx deployment"
  type        = bool
  default     = true
}

variable "ingress_class_name" {
  description = "Ingress class name used for addon ingresses"
  type        = string
  default     = "nginx"
}

variable "ingress_namespace" {
  description = "Namespace for ingress-nginx"
  type        = string
  default     = "ingress-nginx"
}

variable "ingress_nginx_chart_version" {
  description = "Chart version for ingress-nginx"
  type        = string
  default     = null
}

variable "enable_argo_cd" {
  description = "Enable Argo CD deployment"
  type        = bool
  default     = true
}

variable "argo_cd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "argo_cd_chart_version" {
  description = "Chart version for Argo CD"
  type        = string
  default     = null
}

variable "enable_argo_cd_ingress" {
  description = "Enable Argo CD server ingress"
  type        = bool
  default     = true
}

variable "argo_cd_ingress_host" {
  description = "Hostname for Argo CD ingress"
  type        = string
  default     = "argocd.local"
}

variable "enable_kube_prometheus_stack" {
  description = "Enable kube-prometheus-stack deployment"
  type        = bool
  default     = true
}

variable "monitoring_namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "kube_prometheus_stack_chart_version" {
  description = "Chart version for kube-prometheus-stack"
  type        = string
  default     = null
}

variable "enable_grafana" {
  description = "Enable Grafana in kube-prometheus-stack"
  type        = bool
  default     = true
}

variable "enable_grafana_ingress" {
  description = "Enable Grafana ingress"
  type        = bool
  default     = true
}

variable "grafana_ingress_host" {
  description = "Hostname for Grafana ingress"
  type        = string
  default     = "grafana.local"
}

variable "create_route53_records" {
  description = "Whether to create Route53 DNS records for Argo CD and Grafana"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID used for ingress records"
  type        = string
  default     = null
}

variable "enable_external_dns" {
  description = "Enable ExternalDNS deployment"
  type        = bool
  default     = true
}

variable "external_dns_namespace" {
  description = "Namespace for ExternalDNS"
  type        = string
  default     = "kube-system"
}

variable "external_dns_chart_version" {
  description = "Chart version for ExternalDNS"
  type        = string
  default     = null
}

variable "external_dns_service_account_name" {
  description = "Service account name used by ExternalDNS"
  type        = string
  default     = "external-dns"
}

variable "external_dns_irsa_role_arn" {
  description = "IRSA role ARN used by ExternalDNS"
  type        = string
  default     = null
}

variable "external_dns_domain_filters" {
  description = "Domain filters used by ExternalDNS"
  type        = list(string)
  default     = []
}

variable "external_dns_zone_id_filters" {
  description = "Hosted zone ID filters used by ExternalDNS"
  type        = list(string)
  default     = []
}

variable "external_dns_txt_owner_id" {
  description = "TXT owner ID used by ExternalDNS"
  type        = string
  default     = "external-dns"
}

variable "enable_https" {
  description = "Enable HTTPS for ingress endpoints using ACM certificate"
  type        = bool
  default     = true
}

variable "enable_prometheus" {
  description = "Enable Prometheus in kube-prometheus-stack"
  type        = bool
  default     = true
}

variable "enable_kube_api_server_monitoring" {
  description = "Enable kube-apiserver monitoring in kube-prometheus-stack"
  type        = bool
  default     = true
}

variable "helm_timeout_seconds" {
  description = "Timeout for helm releases in seconds"
  type        = number
  default     = 900
}

variable "ingress_lb_wait_seconds" {
  description = "Seconds to wait for ingress-nginx AWS Load Balancer hostname before creating Route53 records"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags to apply to supported resources"
  type        = map(string)
  default     = {}
}