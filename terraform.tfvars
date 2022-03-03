vpc_cidr   = "10.0.0.0/16"
region = "us-east-1"
availability_zone = "us-east-1a"
public_subnet  = "10.0.0.0/24"
private_subnet = "10.0.1.0/24"
project_name = "Demo"
lb_ports = {
    http  = 80
    https = 443
}

ingress_sg_cidr_blocks_ssh = ["0.0.0.0/0"]

ingress_sg_cidr_blocks_http = ["118.189.0.0/16", "116.206.0.0/16", "223.25.0.0/16"]
#ingress_sg_cidr_blocks_http = ["0.0.0.0/0"]

ec2_user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install nginx -y
                systemctl enable nginx
                systemctl start nginx
                EOF
