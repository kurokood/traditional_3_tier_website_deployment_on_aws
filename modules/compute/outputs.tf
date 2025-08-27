# EC2 Instance Outputs
output "application_server_1_id" {
  description = "ID of Application Server 1"
  value       = aws_instance.application_server_1.id
}

output "application_server_2_id" {
  description = "ID of Application Server 2"
  value       = aws_instance.application_server_2.id
}

output "application_server_1_private_ip" {
  description = "Private IP of Application Server 1"
  value       = aws_instance.application_server_1.private_ip
}

output "application_server_2_private_ip" {
  description = "Private IP of Application Server 2"
  value       = aws_instance.application_server_2.private_ip
}

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