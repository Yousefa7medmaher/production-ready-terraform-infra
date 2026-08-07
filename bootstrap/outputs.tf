output "state_bucket_name" {
  description = "Name of the S3 bucket created for Terraform state."
  value       = aws_s3_bucket.state.id
}

output "lock_table_name" {
  description = "DynamoDB table name created for Terraform state locking."
  value       = aws_dynamodb_table.lock.name
}
