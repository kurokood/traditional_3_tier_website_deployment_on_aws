variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "VPC ID must be in valid AWS format (vpc-xxxxxxxx)."
  }
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
  default     = "wordpress"
}