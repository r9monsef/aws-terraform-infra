variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_name" {
  description = "VPC name tag"
  type        = string
}

variable "environment" {
  description = "Environment tag (stage, prod, etc.)"
  type        = string
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 3
}
