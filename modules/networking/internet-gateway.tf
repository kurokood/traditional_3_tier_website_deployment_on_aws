# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "MyIGW"
    Environment = var.environment
    Project     = var.project
  }
}