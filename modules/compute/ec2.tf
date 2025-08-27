# Data source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# User data script template for WordPress setup
locals {
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    
    # Install Apache, PHP, and MySQL client
    yum install -y httpd php php-mysql mysql
    
    # Install EFS utilities
    yum install -y amazon-efs-utils
    
    # Start and enable Apache
    systemctl start httpd
    systemctl enable httpd
    
    # Create mount point for EFS
    mkdir -p /var/www/html
    
    # Mount EFS using DNS name
    echo "${var.efs_dns_name}:/ /var/www/html efs defaults,_netdev" >> /etc/fstab
    mount -a
    
    # Set proper permissions
    chown -R apache:apache /var/www/html
    chmod -R 755 /var/www/html
    
    # Create a simple PHP info page for testing
    cat > /var/www/html/info.php << 'EOL'
<?php
phpinfo();
?>
EOL
    
    # Create a simple index page
    cat > /var/www/html/index.html << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>WordPress Infrastructure Ready</title>
</head>
<body>
    <h1>WordPress Infrastructure is Ready!</h1>
    <p>Server: $(hostname)</p>
    <p>EFS Mount: ${var.efs_dns_name}</p>
    <p>Database: ${var.rds_endpoint}</p>
    <p><a href="/info.php">PHP Info</a></p>
</body>
</html>
EOL
    
    # Restart Apache to ensure all changes take effect
    systemctl restart httpd
  EOF
}

# Application Server 1
resource "aws_instance" "application_server_1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.private_app_subnet_ids[0]
  vpc_security_group_ids = [
    var.webserver_security_group_id,
    var.ssh_security_group_id
  ]

  user_data = base64encode(local.user_data)

  tags = {
    Name        = "ApplicationServer1"
    Environment = var.environment
    Tier        = "Application"
  }

  # Ensure the instance waits for EFS to be available
  depends_on = [var.efs_dns_name]
}

# Application Server 2
resource "aws_instance" "application_server_2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.private_app_subnet_ids[1]
  vpc_security_group_ids = [
    var.webserver_security_group_id,
    var.ssh_security_group_id
  ]

  user_data = base64encode(local.user_data)

  tags = {
    Name        = "ApplicationServer2"
    Environment = var.environment
    Tier        = "Application"
  }

  # Ensure the instance waits for EFS to be available
  depends_on = [var.efs_dns_name]
}