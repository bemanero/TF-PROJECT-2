resource "aws_db_instance" "db" {
  allocated_storage      = var.allocation-storage
  db_name                = var.db_name
  db_subnet_group_name   = var.db_subnet_group_name
  engine                 = var.db_engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = [var.db_sg]
}