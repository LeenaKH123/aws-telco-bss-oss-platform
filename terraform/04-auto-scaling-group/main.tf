data "terraform_remote_state" "iam" {
  backend = "local"

  config = {
    path = "../09-iam-roles/terraform.tfstate"
  }
}
data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../01-networking-vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "alb" {
  backend = "local"

  config = {
    path = "../03-application-load-balancer/terraform.tfstate"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "customer_portal_lt" {
  name_prefix   = "${var.project_name}-portal-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
iam_instance_profile {
  name = data.terraform_remote_state.iam.outputs.ec2_app_instance_profile_name
}

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Telco BSS/OSS Customer Portal - Auto Scaling</h1>" > /var/www/html/index.html
  EOF
  )

  vpc_security_group_ids = [
    data.terraform_remote_state.networking.outputs.web_security_group_id
  ]
}

resource "aws_autoscaling_group" "customer_portal_asg" {
  name                = "${var.project_name}-portal-asg"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4
  vpc_zone_identifier = [
    data.terraform_remote_state.networking.outputs.public_subnet_id,
    data.terraform_remote_state.networking.outputs.public_subnet_b_id
  ]

  target_group_arns = [
    data.terraform_remote_state.alb.outputs.customer_portal_target_group_arn
  ]

  launch_template {
    id      = aws_launch_template.customer_portal_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-portal-asg-instance"
    propagate_at_launch = true
  }
}
