variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "joo-lab"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "Availability zones to use (must supply at least 2)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnets" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnets" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "single_nat_gateway" {
  description = "Use a single shared NAT Gateway instead of one per AZ (cheaper, less resilient)"
  type        = bool
  default     = true
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into EC2 instances (keep tight - avoid 0.0.0.0/0)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_db_security_group" {
  description = "Whether to create the optional database security group"
  type        = bool
  default     = true
}

variable "db_port" {
  description = "Port used by the database security group"
  type        = number
  default     = 5432
}

variable "db_instance_identifier" {
  description = "Identifier for the RDS DB instance"
  type        = string
  default     = "joo-lab-dev-db"
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.4"
}

variable "db_instance_class" {
  description = "RDS DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage size for the RDS instance in GiB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master database username"
  type        = string
  default     = "appuser"
}

variable "backup_retention_days" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the RDS instance"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the DB instance is deleted"
  type        = bool
  default     = true
}

variable "enable_s3_gateway_endpoint" {
  description = "Whether to create a VPC gateway endpoint for S3."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type for the Elastic Beanstalk environment"
  type        = string
  default     = "t3.micro"
}

variable "min_instances" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 4
}

variable "healthcheck_path" {
  description = "Path used for ALB / EB health checks"
  type        = string
  default     = "/"
}

variable "log_retention_days" {
  description = "CloudWatch log retention, in days"
  type        = number
  default     = 30
}

variable "cpu_alarm_threshold" {
  description = "CPU utilization percentage that triggers the high-CPU alarm"
  type        = number
  default     = 80
}

variable "create_sns_topic" {
  description = "Whether to create an SNS topic for CloudWatch alarm notifications"
  type        = bool
  default     = true
}

variable "alarm_email" {
  description = "Optional email address to subscribe to the SNS alarm topic"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional common tags merged into every resource"
  type        = map(string)
  default     = {}
}
