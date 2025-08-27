# RDS DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-wordpress-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name        = "${var.environment}-wordpress-db-subnet-group"
    Environment = var.environment
    Project     = "wordpress"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier = "${var.environment}-wordpress-mysql"

  # Engine configuration
  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.db_instance_class

  # Storage configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true

  # Database configuration
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.database_security_group_id]
  publicly_accessible    = false

  # Backup configuration
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  # Monitoring and performance
  monitoring_interval          = 0
  performance_insights_enabled = false

  # Deletion protection
  skip_final_snapshot = true
  deletion_protection = false

  # Free tier template settings
  apply_immediately = true

  tags = {
    Name        = "${var.environment}-wordpress-mysql"
    Environment = var.environment
    Project     = "wordpress"
  }
}