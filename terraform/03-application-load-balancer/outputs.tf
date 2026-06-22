output "alb_dns_name" {
  value = aws_lb.customer_portal_alb.dns_name
}

output "customer_portal_alb_url" {
  value = "http://${aws_lb.customer_portal_alb.dns_name}"
}
output "customer_portal_target_group_arn" {
  value = aws_lb_target_group.customer_portal_tg.arn
}
output "alb_arn_suffix" {
  value = aws_lb.customer_portal_alb.arn_suffix
}
