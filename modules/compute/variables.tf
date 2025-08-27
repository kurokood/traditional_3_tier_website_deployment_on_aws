# VPC and Networking Variables
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "VPC ID must be in valid AWS format (vpc-xxxxxxxx)."
  }
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least 2 public subnets are required for ALB high availability."
  }
  validation {
    condition     = alltrue([for id in var.public_subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", id))])
    error_message = "All subnet IDs must be in valid AWS format (subnet-xxxxxxxx)."
  }
}

variable "private_app_subnet_ids" {
  description = "List of private application subnet IDs for EC2 instances"
  type        = list(string)
  validation {
    condition     = length(var.private_app_subnet_ids) >= 2
    error_message = "At least 2 private application subnets are required for EC2 high availability."
  }
  validation {
    condition     = alltrue([for id in var.private_app_subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", id))])
    error_message = "All subnet IDs must be in valid AWS format (subnet-xxxxxxxx)."
  }
}

# Security Group Variables
variable "alb_security_group_id" {
  description = "Security group ID for Application Load Balancer"
  type        = string
  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.alb_security_group_id))
    error_message = "ALB security group ID must be in valid AWS format (sg-xxxxxxxx)."
  }
}

variable "webserver_security_group_id" {
  description = "Security group ID for web servers"
  type        = string
  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.webserver_security_group_id))
    error_message = "WebServer security group ID must be in valid AWS format (sg-xxxxxxxx)."
  }
}

variable "ssh_security_group_id" {
  description = "Security group ID for SSH access"
  type        = string
  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.ssh_security_group_id))
    error_message = "SSH security group ID must be in valid AWS format (sg-xxxxxxxx)."
  }
}

# EC2 Configuration Variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
  validation {
    condition     = can(regex("^[a-z][0-9]+[a-z]*\\.[a-z0-9]+$", var.instance_type))
    error_message = "Instance type must be in valid AWS format (e.g., t2.micro, m5.large)."
  }
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
  default     = null
}

# Storage Variables
variable "efs_dns_name" {
  description = "EFS DNS name for mounting"
  type        = string
}

# Database Variables
variable "rds_endpoint" {
  description = "RDS database endpoint"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

# Resource Naming
variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "dev"
}