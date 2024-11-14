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
  source               = "./modules/vpc"
  env                  = var.env
  zone1                = "us-southeast-1a"
  zone2                = "us-southeast-1b"
  public_subnet_cidrs  = ["10.0.128.0/19", "10.0.160.0/19"]
  private_subnet_cidrs = ["10.0.32.0/19", "10.0.64.0/19"]
  cidr_block           = "10.0.0.0/16"
}

module "eks" {
  source           = "./modules/eks"
  env              = var.env
  eks_name         = var.eks_name
  eks_version      = var.eks_version
  subnet_ids       = module.vpc.private_subnet_ids
}