output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ssh_security_group_id" {
  description = "ID of the SSH security group"
  value       = aws_security_group.ssh.id
}

output "webserver_security_group_id" {
  description = "ID of the WebServer security group"
  value       = aws_security_group.webserver.id
}

output "database_security_group_id" {
  description = "ID of the Database security group"
  value       = aws_security_group.database.id
}

output "efs_security_group_id" {
  description = "ID of the EFS security group"
  value       = aws_security_group.efs.id
}