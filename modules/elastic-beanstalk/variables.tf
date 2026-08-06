variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID the environment is deployed into"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the Application Load Balancer"
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs for the EC2 instances"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID to attach to the Application Load Balancer"
  type        = string
}

variable "ec2_security_group_id" {
  description = "Security group ID to attach to the EC2 instances"
  type        = string
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile for EC2 instances"
  type        = string
}

variable "service_role_arn" {
  description = "ARN of the Elastic Beanstalk service role"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the environment"
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

variable "solution_stack_name_regex" {
  description = "Regex used to select the latest matching Elastic Beanstalk solution stack"
  type        = string
  default     = "^64bit Amazon Linux 2023.*Node\\.js.*$"
}

variable "healthcheck_path" {
  description = "Path the load balancer / EB health agent uses for health checks"
  type        = string
  default     = "/"
}

variable "log_retention_days" {
  description = "Number of days to retain instance logs streamed to CloudWatch Logs"
  type        = number
  default     = 30
}

variable "managed_updates_preferred_start_time" {
  description = "Preferred weekly maintenance window for managed platform updates, in UTC (format: DAY:HH:MM)"
  type        = string
  default     = "Sun:03:00"
}

variable "managed_updates_level" {
  description = "Severity level of platform updates to apply automatically (patch or minor)"
  type        = string
  default     = "minor"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
