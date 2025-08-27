output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "database_name" {
  description = "Name of the database"
  value       = aws_db_instance.mysql.db_name
}

# Removed unused outputs: rds_port, db_subnet_group_name