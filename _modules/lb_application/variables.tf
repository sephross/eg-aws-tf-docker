# build lb
variable "app_name" {
  type        = string
  description = "shortform application name"
}

variable "security_groups" {
  type        = set(string)
  description = "list of security groups assoicated with the lb"
}

variable "subnets" {
  type        = set(string)
  description = "load balancer subnets"
}

variable "lb_type" {
  type    = string
  default = "application"
}

variable "ls_port" {
  type    = string
  default = "443"
}

variable "ls_protocol" {
  type    = string
  default = "HTTPS"
}

variable "tg_path" {
  type    = string
  default = "/"
}

variable "tg_vpc" {
  type        = string
  description = "load balancer vpc"
}

variable "tg_port" {
  type    = string
  default = "443"
}

variable "tg_protocol" {
  type    = string
  default = "HTTPS"
}
