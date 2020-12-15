output "aws_ecs_cluster_id" {
  value       = aws_ecs_cluster.main.id
  description = "ecs cluser id"
}

output "aws_ecs_service_id" {
  value       = aws_ecs_service.main.id
  description = "ecs service arn id"
}

output "aws_ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.main.arn
  description = "ecs task definition arn"
}