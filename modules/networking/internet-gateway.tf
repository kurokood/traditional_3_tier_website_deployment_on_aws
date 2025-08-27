# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = var.igw_name
    Environment = var.environment
    Project     = var.project
  }
}