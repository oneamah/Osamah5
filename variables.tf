variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
  sensitive = true
}

variable "name_prefix" {
  description = "Prefix used for resource names"
  type        = string
  default     = "eks"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of AZs for subnets"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "single_nat_gateway" {
  description = "Create one NAT gateway for all private subnets"
  type        = bool
  default     = true
}

variable "nat_gateway_delete_timeout" {
  description = "Timeout for NAT gateway deletion during destroy"
  type        = string
  default     = "60m"
}

variable "create_bastion" {
  description = "Whether to create a bastion host"
  type        = bool
  default     = true
}

variable "bastion_name" {
  description = "Name for bastion host"
  type        = string
  default     = "eks-bastion"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_key_name" {
  description = "Optional EC2 key pair name for bastion SSH"
  type        = string
  default     = null
}

variable "bastion_ami_id" {
  description = "Optional AMI ID for bastion"
  type        = string
  default     = null
}

variable "bastion_allowed_cidrs" {
  description = "CIDR blocks allowed to SSH into bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_security_group_name" {
  description = "Security group name for bastion host"
  type        = string
  default     = "eks-bastion-sg"
}

variable "enable_bastion_ssm" {
  description = "Enable Session Manager access for bastion"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}

variable "eks_cluster_role_name" {
  description = "IAM role name for the EKS control plane"
  type        = string
  default     = "eks-cluster-role"
}

variable "eks_node_group_role_name" {
  description = "IAM role name for EKS managed node groups"
  type        = string
  default     = "eks-node-group-role"
}

variable "create_cluster_admin_user" {
  description = "Whether to create an IAM user for EKS cluster admin access"
  type        = bool
  default     = true
}

variable "cluster_admin_user_name" {
  description = "IAM username for EKS cluster admin"
  type        = string
  default     = "eks-cluster-admin"
}

variable "cluster_admin_user_force_destroy" {
  description = "Whether to force destroy cluster admin user and associated credentials"
  type        = bool
  default     = false
}

variable "create_cluster_admin_access" {
  description = "Whether to grant EKS cluster admin access to configured principal"
  type        = bool
  default     = true
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.31"
}

variable "cluster_authentication_mode" {
  description = "Authentication mode for EKS cluster access entries"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "endpoint_public_access" {
  description = "Enable public access to EKS API endpoint"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Enable private access to EKS API endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "CIDR allowlist for EKS public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to enable"
  type        = list(string)
  default     = []
}

variable "node_group_name" {
  description = "Name of EKS managed node group"
  type        = string
  default     = "eks-node-group"
}

variable "node_ami_type" {
  description = "AMI type for EKS managed node group"
  type        = string
  default     = "AL2_x86_64"
}

variable "node_capacity_type" {
  description = "Capacity type for EKS managed node group"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_instance_types" {
  description = "Instance types for EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired size of EKS managed node group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum size of EKS managed node group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum size of EKS managed node group"
  type        = number
  default     = 3
}

variable "node_max_unavailable" {
  description = "Maximum unavailable nodes during node group update"
  type        = number
  default     = 1
}

variable "create_oidc_provider" {
  description = "Whether to create IAM OIDC provider for EKS IRSA"
  type        = bool
  default     = true
}

variable "oidc_provider_arn" {
  description = "Existing OIDC provider ARN when create_oidc_provider is false"
  type        = string
  default     = null
}

variable "oidc_thumbprint_list" {
  description = "Optional thumbprints for IAM OIDC provider. If null, module auto-discovers thumbprint"
  type        = list(string)
  default     = null
}

variable "service_account_namespace" {
  description = "Kubernetes namespace for service account IAM role"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Kubernetes service account name for IAM role"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "service_account_iam_role_name" {
  description = "IAM role name for Kubernetes service account"
  type        = string
  default     = "eks-service-account-role"
}

variable "service_account_policy_arns" {
  description = "Managed policy ARNs to attach to service account IAM role"
  type        = list(string)
  default     = []
}

variable "service_account_inline_policy_name" {
  description = "Name for optional inline custom policy"
  type        = string
  default     = "eks-service-account-custom-policy"
}

variable "service_account_inline_policy_json" {
  description = "Optional JSON policy document attached to service account role"
  type        = string
  default     = null
}

variable "enable_coredns" {
  description = "Enable CoreDNS addon"
  type        = bool
  default     = true
}

variable "coredns_addon_version" {
  description = "Optional CoreDNS addon version"
  type        = string
  default     = null
}

variable "enable_ingress_nginx" {
  description = "Enable ingress-nginx"
  type        = bool
  default     = true
}

variable "ingress_class_name" {
  description = "Ingress class name for addon ingresses"
  type        = string
  default     = "nginx"
}

variable "ingress_namespace" {
  description = "Namespace for ingress-nginx"
  type        = string
  default     = "ingress-nginx"
}

variable "ingress_nginx_chart_version" {
  description = "Optional ingress-nginx chart version"
  type        = string
  default     = null
}

variable "enable_argo_cd" {
  description = "Enable Argo CD"
  type        = bool
  default     = true
}

variable "enable_argo_cd_ingress" {
  description = "Enable Argo CD ingress"
  type        = bool
  default     = true
}

variable "argo_cd_ingress_host" {
  description = "Ingress host for Argo CD"
  type        = string
  default     = "argocd.local"
}

variable "argo_cd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "argo_cd_chart_version" {
  description = "Optional Argo CD chart version"
  type        = string
  default     = null
}

variable "enable_kube_prometheus_stack" {
  description = "Enable kube-prometheus-stack"
  type        = bool
  default     = true
}

variable "monitoring_namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "kube_prometheus_stack_chart_version" {
  description = "Optional kube-prometheus-stack chart version"
  type        = string
  default     = null
}

variable "enable_grafana" {
  description = "Enable Grafana in monitoring stack"
  type        = bool
  default     = true
}

variable "enable_grafana_ingress" {
  description = "Enable Grafana ingress"
  type        = bool
  default     = true
}

variable "grafana_ingress_host" {
  description = "Ingress host for Grafana"
  type        = string
  default     = "grafana.local"
}

variable "create_route53_records" {
  description = "Whether to create Route53 records for Argo CD and Grafana"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for Argo CD and Grafana records"
  type        = string
  default     = null
}

variable "enable_https" {
  description = "Enable HTTPS for Argo CD and Grafana via ACM + ingress-nginx"
  type        = bool
  default     = true
}

variable "ingress_lb_wait_seconds" {
  description = "Seconds to wait for ingress-nginx load balancer before Route53 records"
  type        = number
  default     = 300
}

variable "enable_external_dns" {
  description = "Enable ExternalDNS for automatic Route53 management"
  type        = bool
  default     = true
}

variable "external_dns_namespace" {
  description = "Namespace for ExternalDNS"
  type        = string
  default     = "kube-system"
}

variable "external_dns_service_account_name" {
  description = "Service account name for ExternalDNS"
  type        = string
  default     = "external-dns"
}

variable "external_dns_iam_role_name" {
  description = "IAM role name for ExternalDNS IRSA"
  type        = string
  default     = "external-dns-role"
}

variable "external_dns_chart_version" {
  description = "Optional ExternalDNS chart version"
  type        = string
  default     = null
}

variable "external_dns_domain_filters" {
  description = "Domain filters for ExternalDNS"
  type        = list(string)
  default     = []
}

variable "external_dns_zone_id_filters" {
  description = "Zone ID filters for ExternalDNS"
  type        = list(string)
  default     = []
}

variable "external_dns_txt_owner_id" {
  description = "TXT owner id for ExternalDNS"
  type        = string
  default     = "external-dns"
}

variable "enable_prometheus" {
  description = "Enable Prometheus in monitoring stack"
  type        = bool
  default     = true
}

variable "enable_kube_api_server_monitoring" {
  description = "Enable kube-apiserver monitoring in monitoring stack"
  type        = bool
  default     = true
}

variable "helm_timeout_seconds" {
  description = "Helm release timeout in seconds"
  type        = number
  default     = 900
}