resource "aws_lb" "demo_lb" {
  name               = "demo-lb"
  load_balancer_type = "network"
  subnets            = [aws_subnet.demo_public_subnet.id]

  tags = {
    Name = "${var.project_name} LB"
  }
}

resource "aws_lb_listener" "demo_lb_listener_ssh" {

  load_balancer_arn = aws_lb.demo_lb.arn

  protocol = "TCP"
  port = 22

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.demo_lb_target_group_ssh.arn
  }
}

resource "aws_lb_listener" "demo_lb_listener_http" {

  load_balancer_arn = aws_lb.demo_lb.arn

  protocol = "TCP"
  port = 80

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.demo_lb_target_group_http.arn
  }
}

resource "aws_lb_target_group" "demo_lb_target_group_ssh" {
  port        = 22
  protocol    = "TCP"
  vpc_id      = aws_vpc.demo_vpc.id

  depends_on = [
    aws_lb.demo_lb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "demo_lb_target_group_http" {
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.demo_vpc.id

  depends_on = [
    aws_lb.demo_lb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "demo_lb_target_group_attachment_ssh" {
  target_group_arn  = aws_lb_target_group.demo_lb_target_group_ssh.arn
  target_id         = aws_instance.demo_ec2.id
  port              = 22
}

resource "aws_lb_target_group_attachment" "demo_lb_target_group_attachment_http" {
  target_group_arn  = aws_lb_target_group.demo_lb_target_group_http.arn
  target_id         = aws_instance.demo_ec2.id
  port              = 80
}