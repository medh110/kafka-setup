variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be created"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs for EKS"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
}

variable "desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
}

variable "min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
}

variable "region" {
  description = "AWS region for EKS"
  type        = string
}
