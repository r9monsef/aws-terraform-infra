provider "aws" {
  region = var.aws_region
}

module "vpc_stage" {
  source = "../../modules/vpc"
  environment = "stage"
  cidr_block = var.stage_vpc_cidr
  vpc_name = "stage-vpc"
}