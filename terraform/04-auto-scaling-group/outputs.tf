output "auto_scaling_group_name" {
  value = aws_autoscaling_group.customer_portal_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.customer_portal_lt.id
}
