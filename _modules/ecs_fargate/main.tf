locals {
  app_name            = var.app_name
  subnets             = var.subnets
  efs_id              = var.efs_id
  security_groups     = var.security_groups
  path_taskDefinition = var.path_taskDefinition
  lb_target_arn       = var.lb_target_arn
  lb_container        = var.lb_container
  lb_port             = var.lb_port
}

# ecs cluster
resource "aws_ecs_cluster" "main" {
  name = "ecs-${local.app_name}"
}

# ecs task
resource "aws_ecs_task_definition" "main" {
  family                   = local.app_name
  container_definitions    = file(local.path_taskDefinition)
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  volume {
    # for_each = local.efs_id != "" ? [1] : []

    name = "efs-${local.app_name}"
    efs_volume_configuration {
      file_system_id = local.efs_id
      root_directory = "/"
    }
  }
}

# ecs service
resource "aws_ecs_service" "main" {
  name             = "ecs-svc-${local.app_name}"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.main.arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  desired_count    = 1

  network_configuration { # network configuration required for Fargate launch type
    subnets          = local.subnets
    security_groups  = local.security_groups
    assign_public_ip = false
  }

  load_balancer {
    # for_each = local.lb_target_arn != "" ? [1] : []

    target_group_arn = local.lb_target_arn
    container_name   = local.lb_container
    container_port   = local.lb_port
  }
}
