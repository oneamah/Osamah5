variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "cluster_oidc_issuer_url" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
}

variable "create_oidc_provider" {
  description = "Whether to create an IAM OIDC provider for the cluster"
  type        = bool
  default     = true
}

variable "oidc_provider_arn" {
  description = "Existing OIDC provider ARN to use when create_oidc_provider is false"
  type        = string
  default     = null
}

variable "oidc_thumbprint_list" {
  description = "Optional thumbprints for IAM OIDC provider. If null, discovered automatically from OIDC issuer TLS chain"
  type        = list(string)
  default     = null
}

variable "service_account_namespace" {
  description = "Kubernetes namespace of the service account"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Kubernetes service account name"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "iam_role_name" {
  description = "IAM role name for the Kubernetes service account"
  type        = string
  default     = "eks-service-account-role"
}

variable "policy_arns" {
  description = "Managed IAM policy ARNs to attach to the service account role"
  type        = list(string)
  default     = []
}

variable "inline_policy_name" {
  description = "Name for optional custom inline policy managed as aws_iam_policy"
  type        = string
  default     = "eks-service-account-custom-policy"
}

variable "inline_policy_json" {
  description = "Optional custom IAM policy JSON to attach to the service account role"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to service account IAM resources"
  type        = map(string)
  default     = {}
}