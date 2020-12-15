module "vpc" {
  source = "./_modules/vpc"

  app_name       = var.app_name
  vpc_cidr       = "10.255.248.0/22"
  subnet_public  = ["10.255.248.0/25", "10.255.249.0/25"]
  subnet_private = ["10.255.248.128/25", "10.255.249.128/25"]
}

module "lb" {
  source = "./_modules/lb_application"

  app_name        = var.app_name
  security_groups = [module.vpc.security_group_id]
  subnets         = module.vpc.subnet_public_id
  ls_port         = "80"
  ls_protocol     = "HTTP"
  tg_path         = "/goals"
  tg_vpc          = module.vpc.vpc_id
  tg_port         = "80"
  tg_protocol     = "HTTP"
}

module "efs" {
  source = "./_modules/efs"

  app_name            = var.app_name
  vpc_id              = module.vpc.vpc_id
  security_groups_ext = [module.vpc.security_group_id]
  subnets             = module.vpc.subnet_private_id
}

module "ecs" {
  source = "./_modules/ecs_fargate"

  app_name            = var.app_name
  security_groups     = [module.vpc.security_group_id]
  subnets             = module.vpc.subnet_private_id
  efs_id              = module.efs.efs_id
  path_taskDefinition = "./_taskDefinitions/goalsTracker.json"
  lb_target_arn       = module.lb.lb_tg_arn
  lb_container        = "goals-api"
  lb_port             = "80"
}


