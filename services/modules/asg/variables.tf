variable "ec2_ami" {
  default = "ami-032930428bf1abbff"
}

variable "security_groups" {
  default = ""
  type = string
}

variable "iam_instance_profile" {
  default = ""
  type = string
}

variable "vpc_zone_identifier" {
  default = []
  type = list(string)
}

variable "target_group_arns" {
  default = []
  type = list(string)
}