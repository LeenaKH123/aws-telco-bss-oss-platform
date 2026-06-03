output "alb_dns_name" {
  value = aws_lb.customer_portal_alb.dns_name
}

output "customer_portal_alb_url" {
  value = "http://${aws_lb.customer_portal_alb.dns_name}"
}