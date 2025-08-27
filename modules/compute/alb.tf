# Application Load Balancer
resource "aws_lb" "wp_site_lb" {
  name               = "${var.environment}-wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.environment}-wordpress-alb"
    Environment = var.environment
    Tier        = "Presentation"
    Project     = "wordpress"
  }
}

# HTTP Listener for ALB
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.wp_site_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_servers.arn
  }

  tags = {
    Name        = "${var.environment}-wordpress-alb-listener"
    Environment = var.environment
    Project     = "wordpress"
  }
}