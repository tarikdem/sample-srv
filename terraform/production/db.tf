resource "aws_db_subnet_group" "production_db_subnet_group" {
  subnet_ids  = [aws_subnet.production_cluster_subnet_1.id, aws_subnet.production_cluster_subnet_2.id]
}

resource "aws_db_instance" "production_db" {
  identifier             = "production-db"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.production_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.production_rds_sg.id]
  publicly_accessible    = false
}