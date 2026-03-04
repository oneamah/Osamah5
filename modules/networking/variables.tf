variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix used for networking resource names"
  type        = string
  default     = "eks"
}

variable "cluster_name" {
  description = "EKS cluster name used for subnet tags"
  type        = string
  default     = "eks-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "single_nat_gateway" {
  description = "Whether to create a single NAT gateway for all private subnets"
  type        = bool
  default     = true
}

variable "nat_gateway_delete_timeout" {
  description = "Timeout for NAT gateway deletion"
  type        = string
  default     = "60m"
}

variable "tags" {
  description = "Tags to apply to networking resources"
  type        = map(string)
  default     = {}
}

variable "create_bastion" {
  description = "Whether to create a bastion host in a public subnet"
  type        = bool
  default     = true
}

variable "bastion_name" {
  description = "Name tag for bastion instance"
  type        = string
  default     = "eks-bastion"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_key_name" {
  description = "Optional EC2 key pair name for SSH access"
  type        = string
  default     = null
}

variable "bastion_ami_id" {
  description = "Optional custom AMI ID for bastion host"
  type        = string
  default     = null
}

variable "bastion_allowed_cidrs" {
  description = "CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_security_group_name" {
  description = "Security group name for bastion host"
  type        = string
  default     = "eks-bastion-sg"
}

variable "enable_bastion_ssm" {
  description = "Enable AWS Systems Manager Session Manager access for bastion"
  type        = bool
  default     = true
}