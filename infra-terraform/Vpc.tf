variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "elastify-prod"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = "prod-vpc"
  cidr                 = "172.16.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["172.16.0.0/18", "172.16.64.0/18", "172.16.128.0/20"]
  public_subnets       = ["172.16.192.0/19", "172.16.160.0/19", "172.16.224.0/19"]
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
 

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
