output "private_subnets" {
  value = data.aws_subnet_ids.private
}

output "public_subnets" {
  value = data.aws_subnet_ids.public
}

output "ecs_cluster_id" {
  value = concat(aws_ecs_cluster.app.*.id, [""])[0]
}

output "ecs_cluster_arn" {
  value = concat(aws_ecs_cluster.app.*.arn, [""])[0]
}

output "main_lb_id" {
  value = concat(aws_alb.main.*.id, [""])[0]
}

output "main_lb_arn" {
  value = concat(aws_alb.main.*.arn, [""])[0]
}

output "main_lb_dns_name" {
  value = concat(aws_alb.main.*.dns_name, [""])[0]
}

output "main_lb_zone_id" {
  value = concat(aws_alb.main.*.zone_id, [""])[0]
}

output "http_tcp_listener_arns" {
  value = aws_alb_listener.http.*.arn
}

output "http_tcp_listener_ids" {
  value = aws_alb_listener.http.*.id
}

output "https_listener_arns" {
  value = aws_alb_listener.https.*.arn
}

output "https_listener_ids" {
  value = aws_alb_listener.https.*.id
}

output "target_group_arns" {
  value = aws_alb_target_group.main.*.arn
}

output "target_group_names" {
  value = aws_alb_target_group.main.*.name
}
