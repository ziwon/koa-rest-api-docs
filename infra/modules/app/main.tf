################################################################################
# ECS Cluster
################################################################################

resource "aws_ecs_cluster" "app" {
  name = var.app
  tags = var.tags
}

resource "aws_ecs_service" "app" {
  name            = var.app
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn

  launch_type = "FARGATE"

  desired_count = var.service_replicas

  health_check_grace_period_seconds = 30

  network_configuration {
    security_groups = [aws_security_group.task.id]
    subnets         = data.aws_subnet_ids.private.ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = var.task_definition.container_name
    container_port   = var.task_definition.container_port
  }

  # workaround for https://github.com/hashicorp/terraform/issues/12634
  depends_on = [
    aws_alb_listener.http,
  ]

  lifecycle {
    ignore_changes = [task_definition]
  }
}

#################################################################################
# Task Definition & Services
#################################################################################

resource "aws_ecs_task_definition" "app" {
  family                   = var.app
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_definition.cpu
  memory                   = var.task_definition.memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.app_role.arn
  container_definitions    = data.template_file.app.rendered
}

data "template_file" "app" {
  template = "${file("modules/app/templates/app_task_definition.json")}"

  vars = {
    app             = var.app
    region          = var.region
    environment     = var.environment
    container_name  = var.task_definition.container_name
    container_image = var.task_definition.container_image
    container_port  = var.task_definition.container_port
  }
}

#################################################################################
# Auto Scaling Target
#################################################################################

resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.app.name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.app_autoscale_max_instances
  min_capacity       = var.app_autoscale_min_instances
}


#################################################################################
# CloutWatch Log Groups
#################################################################################

resource "aws_cloudwatch_log_group" "app" {
  name              = "/fargate/service/${var.app}"
  retention_in_days = "14"
  tags              = var.tags
}
