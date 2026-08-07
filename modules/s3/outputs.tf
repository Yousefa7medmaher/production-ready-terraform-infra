output "bucket_name" {
  description = "Name of the S3 bucket used for Elastic Beanstalk application versions"
  value       = aws_s3_bucket.app_versions.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.app_versions.arn
}
