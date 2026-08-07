variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "db_username" {
  description = "Database username to store in Secrets Manager"
  type        = string
}

variable "db_name" {
  description = "Database name to store in Secrets Manager"
  type        = string
}

variable "db_password" {
  description = "Database password to store in Secrets Manager"
  type        = string
  sensitive   = true
}

variable "secret_name" {
  description = "Optional override for the Secrets Manager secret name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to the Secrets Manager secret"
  type        = map(string)
  default     = {}
}
