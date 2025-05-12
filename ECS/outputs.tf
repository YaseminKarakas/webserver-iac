output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster_webserver_iac.id
}

output "ecs_security_group_id" {
  description = "ID of the security group for Fargate tasks"
  value       = aws_security_group.webserver_ecs_sg.id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.webserver_ecs_service.name
}
