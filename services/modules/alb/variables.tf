variable "vpc_id" {
  default = ""
  type = string
}

variable "private_subnets" {
  default = []
  type = list(string)
}

variable "public_subnets" {
  default = []
  type = list(string)
}

variable "security_group_id" {
  default = ""
  type = string
}

locals {
  http_port = 80
  http_protocol = "HTTP"
}