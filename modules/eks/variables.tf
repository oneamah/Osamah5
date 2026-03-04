variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.31"
}

variable "cluster_authentication_mode" {
  description = "Authentication mode for EKS cluster access management"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  type        = string
}

variable "eks_node_group_role_arn" {
  description = "IAM role ARN used by the EKS managed node group"
  type        = string
}

variable "cluster_subnet_ids" {
  description = "Subnet IDs used by EKS control plane"
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "Subnet IDs used by EKS managed node groups"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Security group ID for the EKS control plane"
  type        = string
}

variable "endpoint_public_access" {
  description = "Enable public API endpoint access"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Enable private API endpoint access"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to access the EKS public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to enable"
  type        = list(string)
  default     = []
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
  default     = "eks-node-group"
}

variable "node_ami_type" {
  description = "AMI type for managed node group"
  type        = string
  default     = "AL2_x86_64"
}

variable "node_capacity_type" {
  description = "Capacity type for managed node group"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_instance_types" {
  description = "EC2 instance types for managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_max_unavailable" {
  description = "Maximum unavailable nodes during node group updates"
  type        = number
  default     = 1
}

variable "create_cluster_admin_access" {
  description = "Whether to create EKS cluster admin access entry and policy association"
  type        = bool
  default     = true
}

variable "cluster_admin_principal_arn" {
  description = "IAM principal ARN to grant EKS cluster admin access"
  type        = string
  default     = null
}

variable "additional_admin_principal_arns" {
  description = "Additional IAM principal ARNs to grant EKS cluster admin access"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {}
}