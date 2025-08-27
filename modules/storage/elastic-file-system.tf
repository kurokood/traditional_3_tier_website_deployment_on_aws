resource "aws_efs_file_system" "main" {
  creation_token = "MyEFS"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  encrypted = true

  tags = {
    Name        = "MyEFS"
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "main" {
  count = length(var.private_app_subnet_ids)

  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.private_app_subnet_ids[count.index]
  security_groups = [var.efs_security_group_id]
}