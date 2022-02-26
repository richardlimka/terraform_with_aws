resource "aws_instance" "demo_ec2" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  
  subnet_id = aws_subnet.demo_private_subnet.id
  vpc_security_group_ids = [aws_security_group.demo_ec2_sg.id]

  tags = {
    Name = "${var.project_name} EC2"
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
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "Allow HTTP from specific subnets"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["118.189.0.0/16", "116.206.0.0/16", "223.25.0.0/16"]
  }


  tags = {
    Name = "${var.project_name} SG"
  }
}
