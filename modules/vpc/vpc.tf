resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.ProjectName}-${var.environment}"
    ProjectName = var.ProjectName
    environment = var.environment
  
  }
}

# creating subnets

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pri_sub_1_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name        = "${var.ProjectName}-pri-subnet-1-${var.environment}"
    ProjectName = var.ProjectName
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pri_sub_2_cidr
  availability_zone = "${var.region}c"
  tags = {
    Name        = "${var.ProjectName}-pri-subnet-2-${var.environment}"
    ProjectName = var.ProjectName
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub_sub_1_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name        = "${var.ProjectName}-pub-subnet-1-${var.environment}"
    ProjectName = var.ProjectName
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub_sub_2_cidr
  availability_zone = "${var.region}c"
  tags = {
    Name        = "${var.ProjectName}-pub-subnet-2-${var.environment}"
    ProjectName = var.ProjectName
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

# associate the subnets to the route table

resource "aws_route_table_association" "rt-tbl-association-private-1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.rt-tbl-private.id
  depends_on = [
    aws_subnet.private_subnet_1,
    aws_route_table.rt-tbl-private
  ]
}

resource "aws_route_table_association" "rt-tbl-association-public-1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.rt-tbl-public.id
  depends_on = [
    aws_subnet.public_subnet_1,
    aws_route_table.rt-tbl-public
  ]
}

resource "aws_route_table_association" "rt-tbl-association-private-2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.rt-tbl-private.id
  depends_on = [
    aws_subnet.private_subnet_2,
    aws_route_table.rt-tbl-private
  ]
}

resource "aws_route_table_association" "rt-tbl-association-public-2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.rt-tbl-public.id
  depends_on = [
    aws_subnet.public_subnet_2,
    aws_route_table.rt-tbl-public
  ]
}

# create internet gateway for VPC

resource "aws_internet_gateway" "int-gtwy" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.ProjectName}-igw-${var.environment}"
    ProjectName = var.ProjectName
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

### NAT GATEWAY

# create elastic IP for NAT gateway

resource "aws_eip" "nat-eip" {
  vpc = true
  tags = {
    Name        = "${var.ProjectName}-nat-eip-${var.environment}"
    ProjectName = var.ProjectName
  }
}

# create NAT gateway
# Note : Added only one subnet

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name        = "${var.ProjectName}-ngw-${var.environment}"
    ProjectName = var.ProjectName
  }
}

### ROUTE TABLE

# create public route table

resource "aws_route_table" "rt-tbl-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int-gtwy.id
  }
  tags = {
    Name        = "${var.ProjectName}-rt-public-${var.environment}"
    ProjectName = var.ProjectName
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

# create private route table

resource "aws_route_table" "rt-tbl-private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name        = "${var.ProjectName}-rt-private-${var.environment}"
    ProjectName = var.ProjectName
  }
  depends_on = [
    aws_vpc.vpc
  ]
}
