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

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "create_cluster_admin_user" {
  description = "Whether to create an IAM user intended for EKS admin access"
  type        = bool
  default     = true
}

variable "cluster_admin_user_name" {
  description = "IAM username for EKS cluster admin"
  type        = string
  default     = "eks-cluster-admin"
}

variable "cluster_admin_user_force_destroy" {
  description = "Whether to force destroy IAM user including access keys and login profile"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}