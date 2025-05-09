variable "aws_region" {
  description = "The AWS region where resources will be created"
  default     = "us-east-1"
}

variable "prod_vpc_cidr" {
  description = "CIDR block for the production VPC"
  default     = "10.0.0.0/16"
}