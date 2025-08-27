# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "ALB-SG"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # HTTP inbound from anywhere
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS inbound from anywhere
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ALB-SG"
    Environment = var.environment
  }
}

# SSH Security Group
resource "aws_security_group" "ssh" {
  name        = "SSH-SG"
  description = "Security group for SSH access"
  vpc_id      = var.vpc_id

  # SSH inbound from anywhere
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "SSH-SG"
    Environment = var.environment
  }
}
# WebServer Security Group
resource "aws_security_group" "webserver" {
  name        = "WebServer-SG"
  description = "Security group for Web Servers"
  vpc_id      = var.vpc_id

  # HTTP inbound from ALB security group
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # HTTPS inbound from ALB security group
  ingress {
    description     = "HTTPS from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # SSH inbound from SSH security group
  ingress {
    description     = "SSH from SSH SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh.id]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "WebServer-SG"
    Environment = var.environment
  }
}

# Database Security Group
resource "aws_security_group" "database" {
  name        = "Database-SG"
  description = "Security group for RDS Database"
  vpc_id      = var.vpc_id

  # MySQL/Aurora inbound from WebServer security group
  ingress {
    description     = "MySQL/Aurora from WebServer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver.id]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Database-SG"
    Environment = var.environment
  }
}

# EFS Security Group
resource "aws_security_group" "efs" {
  name        = "EFS-SG"
  description = "Security group for Elastic File System"
  vpc_id      = var.vpc_id

  # NFS inbound from WebServer security group
  ingress {
    description     = "NFS from WebServer"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver.id]
  }

  # NFS inbound from self (self-reference)
  ingress {
    description = "NFS from self"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
  }

  # SSH inbound from SSH security group
  ingress {
    description     = "SSH from SSH SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh.id]
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "EFS-SG"
    Environment = var.environment
  }
}