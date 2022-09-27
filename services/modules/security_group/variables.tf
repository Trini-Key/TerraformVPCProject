variable "vpc_id" {
  default = ""
  type = string
}

locals {
  http_port = "80"
  http_protocol = "HTTP"
  all_ips = ["0.0.0.0/0"]
  ssh_port = "22"
  any_port = 0
  any_protocol = "-1"
}