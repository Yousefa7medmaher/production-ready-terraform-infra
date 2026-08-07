locals {
  name_prefix = "${var.project_name}-${var.environment}"
  secret_name = var.secret_name != "" ? var.secret_name : "${local.name_prefix}-db-credentials"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = local.secret_name
  description = "Database credentials for ${var.project_name}-${var.environment}"

  tags = merge(var.tags, {
    Name = local.secret_name
  })
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    db_name  = var.db_name
    password = var.db_password
  })
}
