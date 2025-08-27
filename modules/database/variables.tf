variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "VPC ID must be in valid AWS format (vpc-xxxxxxxx)."
  }
}

variable "private_db_subnet_ids" {
  description = "List of private database subnet IDs"
  type        = list(string)
  validation {
    condition     = length(var.private_db_subnet_ids) >= 2
    error_message = "At least 2 database subnets are required for RDS subnet group."
  }
  validation {
    condition     = alltrue([for id in var.private_db_subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", id))])
    error_message = "All subnet IDs must be in valid AWS format (subnet-xxxxxxxx)."
  }
}

variable "database_security_group_id" {
  description = "ID of the database security group"
  type        = string
  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.database_security_group_id))
    error_message = "Security group ID must be in valid AWS format (sg-xxxxxxxx)."
  }
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "wpdb"
}

variable "db_username" {
  description = "Username for the database admin user"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the database admin user"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9!@#$%^&*()_+=-]+$", var.db_password))
    error_message = "Database password can only contain alphanumeric characters and special characters !@#$%^&*()_+=-."
  }
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for RDS instance"
  type        = number
  default     = 20
  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 65536
    error_message = "Allocated storage must be between 20 GB and 65536 GB."
  }
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "dev"
}