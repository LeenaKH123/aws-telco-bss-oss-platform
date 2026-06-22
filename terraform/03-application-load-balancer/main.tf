# Reads output from networking
data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "telco-bss-oss-terraform-state-a7015e3f"
    key    = "01-networking-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "customer_portal" {
  backend = "s3"

  config = {
    bucket = "telco-bss-oss-terraform-state-a7015e3f"
    key    = "02-customer-portal-ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP traffic to Application Load Balancer"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic to EC2 target"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_lb" "customer_portal_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    data.terraform_remote_state.networking.outputs.public_subnet_id,
    data.terraform_remote_state.networking.outputs.public_subnet_b_id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "customer_portal_tg" {
  name     = "${var.project_name}-portal-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.networking.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-portal-tg"
  }
}

resource "aws_lb_target_group_attachment" "customer_portal_attachment" {
  target_group_arn = aws_lb_target_group.customer_portal_tg.arn
  target_id        = data.terraform_remote_state.customer_portal.outputs.customer_portal_instance_id
  port             = 80
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.customer_portal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.customer_portal_tg.arn
  }
}
