resource "aws_launch_configuration" "my_launch_config" {
  image_id = var.ec2_ami
  iam_instance_profile = var.iam_instance_profile
  security_groups = [var.security_groups]
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "MyPrivateKey"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    cd /var/www
    chmod 777 html
    cd html
    echo "<html><body><h1>Deployed via Terraform</h1></body></html>" > index.html
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "asg"
  launch_configuration = aws_launch_configuration.my_launch_config.name
  vpc_zone_identifier = var.vpc_zone_identifier

  target_group_arns = var.target_group_arns
  health_check_type = "ELB"

  desired_capacity = 2
  min_size = 2
  max_size = 4


  tag {
    key = "Name"
    value = "Terraform-asg"
    propagate_at_launch = true
  }
}
