output "eb_service_role_name" {
  description = "Name of the Elastic Beanstalk service role"
  value       = aws_iam_role.eb_service_role.name
}

output "eb_service_role_arn" {
  description = "ARN of the Elastic Beanstalk service role"
  value       = aws_iam_role.eb_service_role.arn
}

output "eb_ec2_role_name" {
  description = "Name of the Elastic Beanstalk EC2 role"
  value       = aws_iam_role.eb_ec2_role.name
}

output "eb_ec2_role_arn" {
  description = "ARN of the Elastic Beanstalk EC2 role"
  value       = aws_iam_role.eb_ec2_role.arn
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.eb_ec2_profile.name
}

output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile"
  value       = aws_iam_instance_profile.eb_ec2_profile.arn
}
