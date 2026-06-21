#print the public IP address of the EC2 instance
output "customer_portal_public_ip" {
  value = aws_instance.customer_portal.public_ip
}
# print the browser URL for the customer portal
output "customer_portal_url" {
  value = "http://${aws_instance.customer_portal.public_ip}"
}
output "customer_portal_instance_id" {
  value = aws_instance.customer_portal.id
}