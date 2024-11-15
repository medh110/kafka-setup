terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_name       = "custom-eks-vpc"
  cidr_block     = "10.0.0.0/16"
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "custom-eks-cluster"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  instance_type   = "t3.small"
  desired_size    = 2
  max_size        = 3
  min_size        = 1
  region          = "ap-southeast-1"
}
