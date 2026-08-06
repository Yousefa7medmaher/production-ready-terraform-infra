output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 (application tier) security group"
  value       = aws_security_group.ec2.id
}

output "db_security_group_id" {
  description = "ID of the database security group (null if not created)"
  value       = var.enable_db_security_group ? aws_security_group.db[0].id : null
}
