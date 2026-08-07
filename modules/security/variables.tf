variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID in which to create the security groups"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into EC2 instances"
  type        = string
}

variable "enable_db_security_group" {
  description = "Whether to create the (optional) database security group"
  type        = bool
  default     = true
}

variable "db_port" {
  description = "Port the database security group allows from the app tier"
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
