output "db_instance_identifier" {
  description = "RDS DB instance identifier"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS DB endpoint address"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Port of the RDS DB instance"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_name" {
  description = "Name of the created DB subnet group"
  value       = aws_db_subnet_group.rds.name
}
