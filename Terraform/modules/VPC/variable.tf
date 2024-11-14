variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "zone1" {
  description = "Zone 1"
  type        = string
  default     = "ap-southeast-1a"
}

variable "zone2" {
  description = "Zone 2"
  type        = string
  default     = "ap-southeast-1b"
}

variable "eks_name" {
  description = "EKS cluster name"
  type        = string
  default     = "demo"
}