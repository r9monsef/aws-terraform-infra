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
    Name        = "${var.vpc_name}-public-subnet-1"
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
    Name        = "${var.vpc_name}-private-subnet-${count.index + 2}"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name        = "${var.vpc_name}-nat-eip"
    Environment = var.environment
  }
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name        = "${var.vpc_name}-nat-gateway"
    Environment = var.environment
  }
}

# Public Route Table (for public subnet)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Environment = var.environment
  }
}

# Private Route Table (for private subnets)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name        = "${var.vpc_name}-private-rt"
    Environment = var.environment
  }
}
locals {
  # Build a map from subnet name suffix to subnet ID
  subnet_name_map = merge(
    { "public-subnet-1" = aws_subnet.public.id },
    { for k, v in aws_subnet.private : "private-subnet-${k + 2}" => v.id }
  )
}

resource "aws_route_table_association" "dynamic_assoc" {
  for_each = var.subnet_route_table_map

  subnet_id = lookup(local.subnet_name_map, each.key, null)

  route_table_id = each.value.type == "public" ? aws_route_table.public.id : aws_route_table.private.id
}