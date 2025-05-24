resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Create 1 public subnet - using subnet index 0 from cidrsubnet (you can customize this)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 0)
  availability_zone       = element(data.aws_availability_zones.available.names, 0)
  tags = {
    Name        = "${var.vpc_name}-public-subnet"
    Environment = var.environment
  }
}

# Create private subnets dynamically using count, starting from subnet index 1 for CIDR subnetting
resource "aws_subnet" "private" {
  count = var.private_subnet_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index + 1)
  availability_zone = element(data.aws_availability_zones.available.names, count.index + 1)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}
