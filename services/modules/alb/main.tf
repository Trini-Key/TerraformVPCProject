resource "aws_lb" "main_app_lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main_app_lb.arn
  port              = local.http_port
  protocol          = local.http_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_tg.arn
  }
}

resource "aws_lb_target_group" "main_tg" {
  name     = "tf-example-lb-tg"
  port     = local.http_port
  protocol = local.http_protocol
  vpc_id   = var.vpc_id

  health_check {
    path = "/index.html"
    port = 80
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}
resource "aws_alb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.front_end.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main_tg.arn
  }

  condition {
    path_pattern {
      values = ["/html/*"]
    }
  }
}

