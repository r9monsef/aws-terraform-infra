variable "aws_region" {
  description = "The AWS region where resources will be created"
  default     = "us-east-1"
}

variable "stage_vpc_cidr" {
  description = "CIDR block for the staging VPC"
  default     = "10.1.0.0/16"
}