variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where the EKS security groups will be created"
  type        = string
}

variable "cluster_security_group_name" {
  description = "Name for EKS cluster security group"
  type        = string
  default     = "eks-cluster-sg"
}

variable "node_security_group_name" {
  description = "Name for EKS node security group"
  type        = string
  default     = "eks-node-sg"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into worker nodes"
  type        = list(string)
  default     = []
}

variable "bastion_security_group_id" {
  description = "Optional bastion security group ID allowed to access cluster and nodes"
  type        = string
  default     = null
}

variable "enable_bastion_rules" {
  description = "Whether to create bastion ingress rules"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to security groups"
  type        = map(string)
  default     = {}
}