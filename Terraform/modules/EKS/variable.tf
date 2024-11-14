variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "eks_name" {
  description = "EKS cluster name"
  type        = string
  default     = " "
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = " "
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster"
}

variable "instance_type" {
   type = string
   description = "Type of EC2 instance to use for the EKS cluster"
   default     = "t3.small"
}

variable "desired_size" {
  description = "Desired size of nodes"
  type        = string
  default     = 1
}

variable "max_size" {
  description = "Max size of nodes"
  type        = string
  default     = 2
}

variable "min_size" {
  description = "Min size of nodes"
  type        = string
  default     = 1
}