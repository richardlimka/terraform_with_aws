vpc_cidr   = "10.0.0.0/24"
public_subnet  = "10.0.0.128/26"
private_subnet = "10.0.0.192/26"
project_name = "Test02"
lb_ports = {
    http  = 80
    https = 443
}