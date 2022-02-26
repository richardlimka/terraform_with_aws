# Create the VPC.
resource "aws_vpc" "demo_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "${var.project_name} VPC"
  }
}

# Create Internet Gateway and attach it to VPC.
resource "aws_internet_gateway" "demo_internet_gw" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "${var.project_name} IG"
  }
}

# Create a Public Subnet.
resource "aws_subnet" "demo_public_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.public_subnet
  tags = {
    Name = "${var.project_name} Public SN"
  }
}

# Create a Private Subnet.
resource "aws_subnet" "demo_private_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.private_subnet
  tags = {
    Name = "${var.project_name} Private SN"
  }
}

# Route table for Public Subnet.
resource "aws_route_table" "demo_public_rt" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_internet_gw.id
  }
  tags = {
    Name = "${var.project_name} Public RT"
  }
}

# Route table for Private Subnet.
resource "aws_route_table" "demo_private_rt" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo_nat_gw.id
  }
  tags = {
    Name = "${var.project_name} Private RT"
  }
}

# Route table association with Public Subnet.
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.demo_public_subnet.id
  route_table_id = aws_route_table.demo_public_rt.id
}

# Route table association with Private Subnet.
resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.demo_private_subnet.id
  route_table_id = aws_route_table.demo_private_rt.id
}

# Create Elastic IP for NAT Gateway.
resource "aws_eip" "demo_nat_eip" {
  vpc = true
  tags = {
    Name = "${var.project_name} eIP"
  }
}

# Create NAT Gateway.
resource "aws_nat_gateway" "demo_nat_gw" {
  allocation_id = aws_eip.demo_nat_eip.id
  subnet_id     = aws_subnet.demo_private_subnet.id
  tags = {
    Name = "${var.project_name} NAT GW"
  }
}