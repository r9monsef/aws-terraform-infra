provider "aws" {
  region = var.aws_region
}

module "vpc_prod" {
  source = "../../modules/vpc"
  environment = "prod"
  cidr_block = var.prod_vpc_cidr
  vpc_name = "prod-vpc"
}