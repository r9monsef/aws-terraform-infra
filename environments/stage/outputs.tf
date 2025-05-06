output "stage_vpc_id" {
  value = module.vpc_stage.vpc_id
}

output "stage_subnet_ids" {
  value = module.vpc_stage.subnet_ids
}