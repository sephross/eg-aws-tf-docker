#outputs
output "lb_arn" {
  value       = aws_lb.main.arn
  description = "load balancer arn"
}

output "lb_tg_arn" {
  value       = aws_lb_target_group.main.arn
  description = "load balancer target group arn"
}

