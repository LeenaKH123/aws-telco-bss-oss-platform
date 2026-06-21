data "terraform_remote_state" "alb" {
  backend = "local"

  config = {
    path = "../03-application-load-balancer/terraform.tfstate"
  }
}

data "terraform_remote_state" "rds" {
  backend = "local"

  config = {
    path = "../05-rds-database/terraform.tfstate"
  }
}

resource "aws_sns_topic" "alerts_topic" {
  name = "${var.project_name}-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "${var.project_name}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Triggers when ALB has more than 5 server errors in 5 minutes"
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    LoadBalancer = data.terraform_remote_state.alb.outputs.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.project_name}-rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers when RDS CPU is above 80 percent"
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    DBInstanceIdentifier = data.terraform_remote_state.rds.outputs.rds_instance_identifier
  }
}
