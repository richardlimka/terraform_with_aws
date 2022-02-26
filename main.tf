resource "aws_iam_user" "test-user1" {
  name = "test-user1"
  tags = {
    Description = "Test User 1"
  }
}

# Create the VPC
resource "aws_vpc" "Main" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "Test01 VPC"
  }
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id
  tags = {
    Name = "Test01 Internet Gateway"
  }
}

# Create a Public Subnet.
resource "aws_subnet" "publicsubnets" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.public_subnets
  tags = {
    Name = "Test01 Public Subnet"
  }
}

# Create a Private Subnet
resource "aws_subnet" "privatesubnets" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.private_subnets
  tags = {
    Name = "Test01 Private Subnet"
  }
}

# Route table for Public Subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "Test01 Public Route Table"
  }
}

# Route table for Private Subnet
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
  tags = {
    Name = "Test01 Private Route Table"
  }
}

# Route table association with Public Subnet
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.publicsubnets.id
  route_table_id = aws_route_table.PublicRT.id
}

# Route table Association with Private Subnet
resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.privatesubnets.id
  route_table_id = aws_route_table.PrivateRT.id
}

resource "aws_eip" "nateIP" {
  vpc = true
  tags = {
    Name = "Test01 Elastic IP"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.publicsubnets.id
  tags = {
    Name = "Test01 NAT Gateway"
  }
}