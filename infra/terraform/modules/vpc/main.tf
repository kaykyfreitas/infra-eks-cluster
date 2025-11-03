resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project     = "EKS-Cluster"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
    Tier = "public"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnet-${count.index + 1}"
    Tier = "private"
  }
}

resource "aws_internet_gateway" "int_gtw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_eip" "eip_nat" {
  count  = length(var.public_subnet_cidr)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gtw" {
  count         = length(var.public_subnet_cidr)
  allocation_id = aws_eip.eip_nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gtw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gtw.id
  }

  tags = {
    Name = "private-route-table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
