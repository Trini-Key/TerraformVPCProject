output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "iam_instance_profile_2" {
  value = aws_iam_instance_profile.ecs_agent.name
}