resource "aws_db_instance" "rds" {
  engine                       = "postgres"
  ca_cert_identifier           = "rds-ca-rsa2048-g1"
  db_name                      = var.db_name
  db_subnet_group_name         = aws_db_subnet_group.subnet_group.name
  engine_version               = var.engine_version
  identifier                   = var.identifier
  instance_class               = var.instance_class
  allocated_storage            = 10
  max_allocated_storage        = 1000
  parameter_group_name         = aws_db_parameter_group.parameter_group.name
  username                     = var.username
  password                     = random_password.db.result
  apply_immediately            = true
  copy_tags_to_snapshot        = true
  performance_insights_enabled = true
  skip_final_snapshot          = true
  storage_encrypted            = true
  vpc_security_group_ids       = var.security_group_ids
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.private_subnet_ids
  tags = {
    "Name" = var.subnet_group_name
  }
}

resource "aws_db_parameter_group" "parameter_group" {
  name        = var.parameter_group_name
  description = "params group"
  family      = var.family
}

resource "random_password" "db" {
  length  = 25
  special = false
}
