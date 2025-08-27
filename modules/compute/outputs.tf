# Removed unused individual EC2 instance outputs for cleaner interface

# Load Balancer Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.wp_site_lb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.wp_site_lb.zone_id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.wp_site_lb.arn
}

# Target Group Outputs
output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app_servers.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.app_servers.name
}