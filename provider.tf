provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.location
  version    = "~> 3.0"

  assume_role {
    # tf execution role arn located in target aws account
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.tf_role_name}"
  }
}
