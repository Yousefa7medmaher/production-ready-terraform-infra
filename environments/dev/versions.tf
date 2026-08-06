terraform {
  required_version = ">= 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # ------------------------------------------------------------------
  # Remote state backend (recommended for anything beyond a solo lab).
  #
  # Uncomment and fill in a pre-existing, versioned S3 bucket + DynamoDB
  # lock table before running `terraform init` in a shared/team context.
  # Backend blocks cannot use variables, so values must be hardcoded here
  # or supplied via `terraform init -backend-config=...`.
  #
  # backend "s3" {
  #   bucket         = "joo-lab-terraform-state"
  #   key            = "dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "joo-lab-terraform-locks"
  #   encrypt        = true
  # }
}
