data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "telco-bss-oss-terraform-state-a7015e3f"
    key    = "01-networking-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "telco-bss-oss-terraform-state-a7015e3f"
    key    = "08-security-hardening/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.terraform_remote_state.security.outputs.db_secret_arn
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}




resource "aws_db_subnet_group" "telco_db_subnet_group" {
  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    data.terraform_remote_state.networking.outputs.private_subnet_id,
    data.terraform_remote_state.networking.outputs.private_subnet_b_id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow database access from application layer"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    description     = "Allow PostgreSQL from web/app security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.networking.outputs.web_security_group_id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_db_instance" "telco_postgres" {
  identifier        = "${var.project_name}-postgres-db"
  engine            = "postgres"
  engine_version    = "16.3"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "telcodb"
  username = local.db_credentials.username
  password = local.db_credentials.password

  db_subnet_group_name   = aws_db_subnet_group.telco_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-postgres-db"
  }
}
