resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  identifier          = var.db_name
  username            = var.db_username
  password            = var.db_password
  parameter_group_name = "default.mysql8.0"
  publicly_accessible = false
  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name = var.db_subnet_group
  skip_final_snapshot  = true
  multi_az            = false

  tags = {
    Name = "${var.project_name}-rds"
  }
}
