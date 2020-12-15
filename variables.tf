# account
variable "account_id" {
  type        = string
  description = "id of target aws account"
}

variable "tf_role_name" {
  type        = string
  description = "name of terraform execution role. Not an ARN"
}

variable "access_key" {
  type        = string
  description = "tf account aws access key"
}

variable "secret_key" {
  type        = string
  description = "tf account aws secret key"
}

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
  default     = []
}
