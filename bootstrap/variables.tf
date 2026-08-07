variable "aws_region" {
  description = "AWS region for backend resources."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform locking."
  type        = string
  default     = "terraform-state-lock"
}

variable "tags" {
  description = "Tags to apply to bootstrap backend resources."
  type        = map(string)
  default = {
    ManagedBy   = "Terraform Bootstrap"
    Environment = "bootstrap"
  }
}
