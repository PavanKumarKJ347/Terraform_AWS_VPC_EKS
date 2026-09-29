resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC" }, var.common_tags)
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC_PublicSubnet-${count.index + 1}", "kubernetes.io/role/elb" : "1" }, var.common_tags)
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC_PrivateSubnet-${count.index + 1}", "kubernetes.io/role/elb" : "1" }, var.common_tags)
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC_InternetGateway" }, var.common_tags)
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC_PublicRouteTable" }, var.common_tags)
}

resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_subnet_cidrs)

  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_eip" "elastic_ips" {
  count = length(var.public_subnet_cidrs)

  domain = "vpc"

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC_ElasticIP-${count.index + 1}" }, var.common_tags)
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.elastic_ips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  depends_on = [aws_internet_gateway.internet_gateway]

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC_NATGateway-${count.index + 1}" }, var.common_tags)
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge({ "Name" : "${var.project}_${var.environment}_VPC_PrivateRouteTable-${count.index + 1}" }, var.common_tags)
}

resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_subnet_cidrs)

  route_table_id = aws_route_table.private_route_table[count.index].id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}