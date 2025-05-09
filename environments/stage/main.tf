module "vpc_stage" {
  source = "../../modules/vpc"
  environment = var.environment
  cidr_block = var.stage_vpc_cidr
  vpc_name = var.vpc_name
}