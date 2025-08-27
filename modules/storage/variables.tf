variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "VPC ID must be in valid AWS format (vpc-xxxxxxxx)."
  }
}

variable "private_app_subnet_ids" {
  description = "IDs of private application subnets for EFS mount targets"
  type        = list(string)
  validation {
    condition     = length(var.private_app_subnet_ids) >= 2
    error_message = "At least 2 application subnets are required for EFS mount targets."
  }
  validation {
    condition     = alltrue([for id in var.private_app_subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", id))])
    error_message = "All subnet IDs must be in valid AWS format (subnet-xxxxxxxx)."
  }
}

variable "efs_security_group_id" {
  description = "Security group ID for EFS"
  type        = string
  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.efs_security_group_id))
    error_message = "Security group ID must be in valid AWS format (sg-xxxxxxxx)."
  }
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "dev"
}