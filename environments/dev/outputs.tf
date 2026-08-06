############################################
# Networking
############################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.networking.private_db_subnet_ids
}

############################################
# Security
############################################

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = module.security.alb_security_group_id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = module.security.ec2_security_group_id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = module.security.db_security_group_id
}

############################################
# IAM
############################################

output "eb_service_role_name" {
  description = "Name of the Elastic Beanstalk service role"
  value       = module.iam.eb_service_role_name
}

output "eb_ec2_role_name" {
  description = "Name of the Elastic Beanstalk EC2 role"
  value       = module.iam.eb_ec2_role_name
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = module.iam.instance_profile_name
}

############################################
# S3
############################################

output "s3_bucket_name" {
  description = "Name of the S3 bucket used for application versions"
  value       = module.s3.bucket_name
}

############################################
# Elastic Beanstalk
############################################

output "eb_application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = module.elastic_beanstalk.application_name
}

output "eb_environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk.environment_name
}

output "alb_dns_name" {
  description = "DNS name (CNAME) of the environment's Application Load Balancer"
  value       = module.elastic_beanstalk.endpoint_url
}

output "environment_url" {
  description = "Full HTTP URL of the Elastic Beanstalk environment"
  value       = "http://${module.elastic_beanstalk.endpoint_url}"
}

############################################
# CloudWatch
############################################

output "cloudwatch_log_group" {
  description = "CloudWatch log group receiving Elastic Beanstalk instance logs"
  value       = module.cloudwatch.log_group_name
}

output "sns_alarm_topic_arn" {
  description = "ARN of the SNS topic used for alarm notifications"
  value       = module.cloudwatch.sns_topic_arn
}
