module "vpc" {
  source = "/Users/keironjerome/Documents/TerraformVPCProject/dev"
}

// SG to only allow SSH connections from VPC public subnets
resource "aws_security_group" "allow_web_ssh_private" {
  name        = "allow_web_ssh_private"
  description = "Allow Web and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  #  ingress {
  #    description               = "app-instance-ingress"
  #    from_port                 = 0
  #    to_port                   = 0
  #    protocol                  = "-1"
  #    self                      = true
  #  }

  ingress {
    description = "SSH only from internal VPC clients"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_public_sg.id]
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    description = "Web only from internal VPC clients"
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_public_sg.id]
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_tf_qa_allow_web_ssh_private"
    Stack = "Qa"
  }
}

resource "aws_security_group" "alb_public_sg" {
  name        = "allow_vpc_public"
  description = "allow alb inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH only from internal VPC clients"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web only from internal VPC clients"
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_tf_qa_alb_public_sg"
    Stack = "Qa"
  }
}