# Target Group for Application Servers
resource "aws_lb_target_group" "app_servers" {
  name     = "${var.environment}-wordpress-app-servers"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Health check configuration
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = {
    Name        = "${var.environment}-wordpress-app-servers"
    Environment = var.environment
    Tier        = "Application"
    Project     = "wordpress"
  }
}

# Target Group Attachment for Application Server 1
resource "aws_lb_target_group_attachment" "app_server_1" {
  target_group_arn = aws_lb_target_group.app_servers.arn
  target_id        = aws_instance.application_server_1.id
  port             = 80
}

# Target Group Attachment for Application Server 2
resource "aws_lb_target_group_attachment" "app_server_2" {
  target_group_arn = aws_lb_target_group.app_servers.arn
  target_id        = aws_instance.application_server_2.id
  port             = 80
}