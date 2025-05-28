aws_region      = "us-east-1"
stage_vpc_cidr   = "172.16.0.0/16"
vpc_name      = "stage-vpc"
environment   = "stage"
subnet_route_table_map = {
  "public-subnet-1" = { type = "public" }
  "private-subnet-2" = { type = "private" }
  "private-subnet-3" = { type = "private" }
}