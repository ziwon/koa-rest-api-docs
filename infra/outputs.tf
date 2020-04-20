output "private_subnets" {
  value = module.app.private_subnets
}

output "public_subnets" {
  value = module.app.public_subnets
}

output "ecs_cluster_id" {
  value = module.app.ecs_cluster_id
}

output "ecs_cluster_arn" {
  value = module.app.ecs_cluster_arn
}

output "main_lb_id" {
  value = module.app.main_lb_id
}

output "main_lb_arn" {
  value = module.app.main_lb_arn
}

output "main_lb_dns_name" {
  value = module.app.main_lb_dns_name
}

output "main_lb_zone_id" {
  value = module.app.main_lb_zone_id
}

output "http_tcp_listener_arns" {
  value = module.app.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  value = module.app.http_tcp_listener_ids
}

output "https_listener_arns" {
  value = module.app.https_listener_arns
}

output "https_listener_ids" {
  value = module.app.https_listener_ids
}

output "target_group_arns" {
  value = module.app.target_group_arns
}

output "target_group_names" {
  value = module.app.target_group_names
}
