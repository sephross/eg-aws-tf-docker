# set locals
locals {
  security_groups = var.security_groups
  subnets         = var.subnets
  lb_type         = var.lb_type
  ls_port         = var.ls_port
  ls_protocol     = var.ls_protocol
  tg_path         = var.tg_path
  tg_vpc          = var.tg_vpc
  tg_port         = var.tg_port
  tg_protocol     = var.tg_protocol
}

# load balancer 
resource "aws_lb" "main" {
  name               = "lb-${var.app_name}"
  internal           = false
  load_balancer_type = local.lb_type
  security_groups    = local.security_groups
  subnets            = local.subnets

  tags = {
    project = var.app_name
  }
}

# http listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = local.ls_port
  protocol          = local.ls_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# target group
resource "aws_lb_target_group" "main" {
  depends_on  = [aws_lb.main]
  name        = "lb-tg-${var.app_name}"
  port        = local.tg_port
  protocol    = local.tg_protocol
  target_type = "ip"
  vpc_id      = local.tg_vpc

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 180
    path                = local.tg_path
    port                = 80
  }
}
