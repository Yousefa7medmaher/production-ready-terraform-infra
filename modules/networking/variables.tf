variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to spread subnets across (must have at least 2)"
  type        = list(string)

  validation {
    condition     = length(var.azs) >= 2
    error_message = "At least two availability zones must be provided for a load-balanced, highly-available environment."
  }
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
}

variable "private_app_subnets" {
  description = "CIDR blocks for private application subnets (one per AZ)"
  type        = list(string)
}

variable "private_db_subnets" {
  description = "CIDR blocks for private database subnets (one per AZ)"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "If true, create a single NAT Gateway shared by all AZs (cheaper, less resilient). If false, one NAT Gateway per AZ."
  type        = bool
  default     = true
}

variable "enable_s3_gateway_endpoint" {
  description = "If true, create a VPC gateway endpoint for S3 so private subnets can access S3 without using the NAT gateway."
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region used by the VPC endpoint service name."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
