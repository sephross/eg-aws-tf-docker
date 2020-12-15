locals {
  vpc_id              = var.vpc_id
  app_name            = var.app_name
  subnets             = var.subnets
  security_groups_ext = var.security_groups_ext
}

# efs security group
resource "aws_security_group" "efs" {
  name        = "allow_nfs"
  description = "allow nfs"
  vpc_id      = local.vpc_id

  ingress {
    description     = "allow nfs"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = local.security_groups_ext
  }

  tags = {
    project = local.app_name
    type    = "efs-secuirty-group"
  }
}

# efs
resource "aws_efs_file_system" "main" {
  creation_token = "efs-${local.app_name}"

  tags = {
    Name    = "efs-${local.app_name}"
    project = local.app_name
  }
}

# efs mount points
resource "aws_efs_mount_target" "main" {
  for_each        = local.subnets != [] ? toset(local.subnets) : []
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs.id]
}
