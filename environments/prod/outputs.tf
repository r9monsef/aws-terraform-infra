output "prod_vpc_id" {
  value = module.vpc_prod.vpc_id
}

output "prod_subnet_ids" {
  value = module.vpc_prod.subnet_ids
}