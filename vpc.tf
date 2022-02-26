# Create the VPC.
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "${var.vpc_name} VPC"
  }
}

# Create Internet Gateway and attach it to VPC.
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.vpc_name} IG"
  }
}

# Create a Public Subnet.
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet
  tags = {
    Name = "${var.vpc_name} Public SN"
  }
}

# Create a Private Subnet.
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet
  tags = {
    Name = "${var.vpc_name} Private SN"
  }
}

# Route table for Public Subnet.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "${var.vpc_name} Public RT"
  }
}

# Route table for Private Subnet.
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "${var.vpc_name} Private RT"
  }
}

# Route table association with Public Subnet.
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Route table Association with Private Subnet.
resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Create Elastic IP for NAT.
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "${var.vpc_name} eIP"
  }
}

# Create NAT Gateway.
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "${var.vpc_name} NAT GW"
  }
}