// SG to only allow SSH connections from VPC public subnets
resource "aws_security_group" "allow_web_ssh_private" {
  name        = "allow_web_ssh_private"
  description = "Allow Web and SSH inbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs_tf_qa_allow_web_ssh_private"
    Stack = "Qa"
  }
}

resource "aws_security_group_rule" "allow_ssh_private" {
  description = "SSH only from internal VPC clients"
  from_port   = local.ssh_port
  to_port     = local.ssh_port
  protocol    = local.http_protocol
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.allow_web_ssh_private.id
  type = "ingress"
}

resource "aws_security_group_rule" "allow_web_private" {
  description = "Web only from internal VPC clients"
  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.http_protocol
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.allow_web_ssh_private.id
  type = "ingress"
}

resource "aws_security_group_rule" "allow_all_private" {
  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.allow_web_ssh_private.id
  type = "egress"
  }

resource "aws_security_group" "alb_public_sg" {
  name        = "allow_vpc_public"
  description = "allow alb inbound"
  vpc_id      = var.vpc_id

  tags = {
    Name  = "ecs_tf_qa_alb_public_sg"
    Stack = "Qa"
  }
}

resource "aws_security_group_rule" "alb_public_ssh" {
  description = "SSH only from internal VPC clients"
  from_port   = local.ssh_port
  to_port     = local.ssh_port
  protocol    = local.http_protocol
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.alb_public_sg.id
  type = "ingress"
}

resource "aws_security_group_rule" "alb_public_web" {
  description = "Web only from internal VPC clients"
  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.http_protocol
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.alb_public_sg.id
  type = "ingress"
  }

resource "aws_security_group_rule" "allow_all_public" {
  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
  security_group_id = aws_security_group.alb_public_sg.id
  type = "egress"
}
