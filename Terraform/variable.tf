variable "region" {
  description = "Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "eks_name" {
  description = "EKS cluster name"
  type        = string
  default     = "demo"
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.29"
}
