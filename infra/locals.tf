locals {
  proj_id = "${var.project}-${var.app}"
  app_id  = "${var.project}-${var.app}-${var.environment}"

  kms_arn = var.kms_arn == "" ? "*" : var.kms_arn

  # {data.aws_ecr_repository.app.repository_url}:${lookup(local.task_config, "image_tag")}
}
