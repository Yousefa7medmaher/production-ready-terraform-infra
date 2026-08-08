locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_db_subnet_group" "rds" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  identifier              = var.db_instance_identifier
  engine                  = var.db_engine
  engine_version          = var.db_engine_version != "" ? var.db_engine_version : null
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  storage_encrypted       = true
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.rds.id
  vpc_security_group_ids  = [var.db_security_group_id]
  backup_retention_period       = var.backup_retention_days
  deletion_protection           = var.deletion_protection
  skip_final_snapshot           = var.skip_final_snapshot
  auto_minor_version_upgrade    = true
  apply_immediately             = false

  db_name   = var.db_name
  username  = var.db_username
  password  = var.db_password

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-db"
  })
}
