module "global" {
  source = "./modules/global"
  name   = local.app_id
}


module "app" {
  source = "./modules/app"

  internal_load_balancer = false

  vpc_id           = var.vpc_id
  app              = local.app_id
  region           = var.region
  environment      = var.environment
  service_replicas = var.service_replicas
  task_definition  = var.task_definition
  certificate_arn  = var.certificate_arn
  kms_arn          = local.kms_arn

  tags = merge(
    map("Last Updated", "${module.global.build_time}"),
    var.tags
  )
}


