variable "vpc_cidr" {}
variable "region" {}
variable "availability_zone" {}
variable "public_subnet" {}
variable "private_subnet" {}
variable "project_name" {}
variable "lb_ports" {
  type = map(number)
}
variable "ingress_sg_cidr_blocks_ssh" {
  type = list(string)
}
variable "ingress_sg_cidr_blocks_http" {
  type = list(string)
}
variable "ec2_user_data" {}