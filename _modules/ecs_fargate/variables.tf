variable "location" {
  type        = string
  description = "aws region"
  default     = "us-east-2"
}

# build
variable "app_name" {
  type        = string
  description = "shortform application name"
}

variable "subnets" {
  type        = list(string)
  description = "list of subnet ids"
  default     = []
}

variable "security_groups" {
  description = "list of security groups associated with esc cluster"
  default     = []
}

# ecs
variable "path_taskDefinition" {
  type        = string
  description = "path to deployment for task definitions of ecs"
}

# optional load balancer
variable "lb_target_arn" {
  type        = string
  description = "optional lb target group arn"
  default     = ""
}

variable "lb_container" {
  type        = string
  description = "container endpoint for application load balancer"
}

variable "lb_port" {
  type        = string
  description = "port load balancer is listening on"
}

# options efs volume
variable "efs_id" {
  type        = string
  description = "id of options efs volume"
  default     = ""
}
