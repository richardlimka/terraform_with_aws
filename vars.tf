variable "vpc_cidr" {}
variable "public_subnet" {}
variable "private_subnet" {}
variable "project_name" {}
variable "lb_ports" {
  type = map(number)
}