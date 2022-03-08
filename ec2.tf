resource "aws_instance" "demo_private_ec2" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  
  subnet_id = aws_subnet.demo_private_subnet.id
  vpc_security_group_ids = [aws_security_group.demo_ec2_sg.id]

  user_data = var.ec2_user_data
  
  tags = {
    Name = "${var.project_name} Private EC2"
  }
}

# Included for the purpose of testing, and as bastion host.
resource "aws_instance" "demo_public_ec2" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  
  subnet_id = aws_subnet.demo_public_subnet.id
  vpc_security_group_ids = [aws_security_group.demo_ec2_sg.id]

  user_data = var.ec2_user_data
  
  tags = {
    Name = "${var.project_name} Public EC2"
  }
}

resource "aws_security_group" "demo_ec2_sg" {
  name        = "demo_ec2_sg"
  description = "Allow SSH HTTP inbound traffic"

    vpc_id = aws_vpc.demo_vpc.id

  ingress {
    description      = "Allow SSH from All Source"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.ingress_sg_cidr_blocks_ssh
  }

  ingress {
    description      = "Allow HTTP from specific subnets"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.ingress_sg_cidr_blocks_http
  }

  # For troubleshooting purpose.
    ingress {
    description      = "For troubleshooting purpose"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.project_name} SG"
  }
}
