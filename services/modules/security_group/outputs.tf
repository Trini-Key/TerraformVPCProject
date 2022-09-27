output "private_security_group_id" {
  value = aws_security_group.allow_web_ssh_private.id
}

output "public_security_group_id" {
  value = aws_security_group.alb_public_sg.id
}