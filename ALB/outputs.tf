output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.webserver_alb.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.webserver_alb.arn
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.webserver_tg.arn
}

output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.webserver_alb_sg.id
}

output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.http_listener.arn
}