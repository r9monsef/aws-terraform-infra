aws_region      = "us-east-1"
prod_vpc_cidr   = "10.0.0.0/16"
vpc_name      = "prod-vpc"
environment   = "prod"
subnet_route_table_map = {
  "public-subnet-1" = { type = "public" }
  "private-subnet-2" = { type = "private" }
  "private-subnet-3" = { type = "private" }
}