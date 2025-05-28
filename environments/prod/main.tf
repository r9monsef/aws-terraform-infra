module "vpc_prod" {
  source = "../../modules/vpc"
  environment = var.environment
  cidr_block = var.prod_vpc_cidr
  vpc_name = var.vpc_name
  subnet_route_table_map = var.subnet_route_table_map
}