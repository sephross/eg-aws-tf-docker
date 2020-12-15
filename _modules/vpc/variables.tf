# build
variable "location" {
  type        = string
  description = "aws region"
  default     = "us-east-2"
}

variable "app_name" {
  type        = string
  description = "shortform application name"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc network in cidr format"
  default     = "10.255.255.0/24"
}

variable "subnet_public" {
  type        = list(string)
  description = "list of public subnet cidr block values"
  default     = []
}

variable "subnet_private" {
  type        = list(string)
  description = "list of private subnet cidr block values"
  default     = ["10.255.255.0/28"]
}
