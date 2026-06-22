output "ec2_app_role_name" {
  value = aws_iam_role.ec2_app_role.name
}

output "ec2_app_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_app_instance_profile.name
}
