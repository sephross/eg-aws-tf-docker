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

variable "vpc_id" {
  type        = string
  description = "efs vpc id"
}

variable "subnets" {
  type        = list(string)
  description = "list of subnet ids"
  default     = []
}

variable "security_groups_ext" {
  description = "list of external security group ids that will be allowed inbound access to the nfs secruity group"
  default     = []
}
