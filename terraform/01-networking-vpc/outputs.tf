# output displays information after deployment
output "vpc_id" {
  value = aws_vpc.telco_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "web_security_group_id" {
  value = aws_security_group.web_sg.id
}
output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}

