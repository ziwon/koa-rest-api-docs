#############################################################
# LB Security Group
#############################################################

resource "aws_security_group" "lb" {
  name   = "${var.app}-lb"
  vpc_id = var.vpc_id
  tags   = merge(map("Name", var.app), var.tags)
}

resource "aws_security_group_rule" "lb_egress_rule" {
  type              = "egress"
  from_port         = var.task_definition.container_port
  to_port           = var.task_definition.container_port
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.lb.id
}

#############################################################
# Task Security Group
#############################################################

resource "aws_security_group" "task" {
  name   = "${var.app}-task"
  vpc_id = var.vpc_id
  tags   = merge(map("Name", var.app), var.tags)
}

resource "aws_security_group_rule" "task_egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.task.id
}

resource "aws_security_group_rule" "task_ingress_rule" {
  type              = "ingress"
  from_port         = var.task_definition.container_port
  to_port           = var.task_definition.container_port
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.task.id
}

