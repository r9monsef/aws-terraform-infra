variable "stage_vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. prod)"
}

variable "aws_region" {
  type        = string
  description = "region"
}