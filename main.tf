# Root Terraform configuration for WordPress infrastructure
# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# Data source to validate AWS region availability
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source to get current AWS region
data "aws_region" "current" {}

# Data source to get current AWS caller identity for validation
data "aws_caller_identity" "current" {}

# Local values for validation and error handling
locals {
  # Validate that specified availability zones are available in the region
  available_azs = data.aws_availability_zones.available.names
  specified_azs = ["us-east-1a", "us-east-1b"]

  # Check if all specified AZs are available
  az_validation = alltrue([
    for az in local.specified_azs : contains(local.available_azs, az)
  ])

  # Validate CIDR blocks don't overlap
  all_cidrs = concat(
    ["10.0.0.0/24", "10.0.1.0/24"],                              # public subnets
    ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"] # private subnets
  )
}

provider "aws" {
  region = "us-east-1"
}

# Validation checks using check blocks (Terraform 1.5+)
check "availability_zones_valid" {
  assert {
    condition     = local.az_validation
    error_message = "One or more specified availability zones are not available in the current region. Available AZs: ${join(", ", local.available_azs)}"
  }
}

check "aws_credentials_configured" {
  assert {
    condition     = data.aws_caller_identity.current.account_id != ""
    error_message = "AWS credentials are not properly configured. Please configure AWS CLI or set environment variables."
  }
}

check "region_matches_azs" {
  assert {
    condition     = data.aws_region.current.name == "us-east-1"
    error_message = "Current AWS region (${data.aws_region.current.name}) does not match the required region (us-east-1)."
  }
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  # Hardcoded values as per requirements
  vpc_name = "MyVPC"
  vpc_cidr = "10.0.0.0/16"
  region   = "us-east-1"

  # Public subnet CIDR blocks
  public_subnet_cidrs = [
    "10.0.0.0/24", # us-east-1a
    "10.0.1.0/24"  # us-east-1b
  ]

  # Private subnet CIDR blocks
  private_subnet_cidrs = [
    "10.0.2.0/24", # Application subnet us-east-1a
    "10.0.3.0/24", # Application subnet us-east-1b
    "10.0.4.0/24", # Database subnet us-east-1a
    "10.0.5.0/24"  # Database subnet us-east-1b
  ]

  # Availability zones
  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  # Internet Gateway name
  igw_name = "MyIGW"
}

# Security Module
module "security" {
  source = "./modules/security"

  vpc_id = module.networking.vpc_id

  depends_on = [module.networking]
}

# Database Module
module "database" {
  source = "./modules/database"

  vpc_id                     = module.networking.vpc_id
  private_db_subnet_ids      = module.networking.private_database_subnet_ids
  database_security_group_id = module.security.database_security_group_id

  # Hardcoded database values as per requirements
  db_name     = "wpdb"
  db_username = "admin"
  db_password = "wordpress123!" # In production, use AWS Secrets Manager

  depends_on = [module.networking, module.security]
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  vpc_id                 = module.networking.vpc_id
  private_app_subnet_ids = module.networking.private_application_subnet_ids
  efs_security_group_id  = module.security.efs_security_group_id

  depends_on = [module.networking, module.security]
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  private_app_subnet_ids = module.networking.private_application_subnet_ids

  # Security groups
  alb_security_group_id       = module.security.alb_security_group_id
  webserver_security_group_id = module.security.webserver_security_group_id
  ssh_security_group_id       = module.security.ssh_security_group_id

  # Storage and database connections - dynamic passing as per requirements
  efs_dns_name = module.storage.efs_dns_name
  rds_endpoint = module.database.rds_endpoint
  db_name      = module.database.database_name

  depends_on = [module.networking, module.security, module.database, module.storage]
}

# Root-level outputs to expose important infrastructure information
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.rds_endpoint
  sensitive   = true
}

output "efs_dns_name" {
  description = "EFS DNS name for mounting"
  value       = module.storage.efs_dns_name
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_application_subnet_ids" {
  description = "IDs of private application subnets"
  value       = module.networking.private_application_subnet_ids
}

output "private_database_subnet_ids" {
  description = "IDs of private database subnets"
  value       = module.networking.private_database_subnet_ids
}