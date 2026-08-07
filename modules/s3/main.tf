
# S3 Module - joo-lab
# Bucket for Elastic Beanstalk application version bundles.


locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# Random suffix keeps the bucket name globally unique without the caller
# having to coordinate a unique name by hand.
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app_versions" {
  bucket = "${local.name_prefix}-app-versions-${random_id.bucket_suffix.hex}"

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-app-versions"
  })
}

resource "aws_s3_bucket_versioning" "app_versions" {
  bucket = aws_s3_bucket.app_versions.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_versions" {
  bucket = aws_s3_bucket.app_versions.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "app_versions" {
  bucket = aws_s3_bucket.app_versions.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "app_versions" {
  bucket = aws_s3_bucket.app_versions.id

  rule {
    id     = "expire-old-app-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_transition {
      noncurrent_days = var.noncurrent_version_transition_days
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
