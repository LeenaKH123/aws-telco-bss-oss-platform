data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../01-networking-vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "customer_portal" {
  backend = "local"

  config = {
    path = "../02-customer-portal-ec2/terraform.tfstate"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP access to Application Load Balancer"
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
    data.terraform_remote_state.networking.outputs.public_subnet_id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}