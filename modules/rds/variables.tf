variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "db_subnet_ids" {
  description = "Private DB subnet IDs used by the RDS subnet group"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "Security group ID used to control access to the RDS instance"
  type        = string
}

variable "db_instance_identifier" {
  description = "Unique identifier for the RDS DB instance"
  type        = string
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Engine version for the RDS instance. Leave blank to use the provider default supported version."
  type        = string
  default     = ""
}

variable "db_instance_class" {
  description = "Instance class for the RDS DB instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage size for the RDS DB instance in gigabytes"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "db_name" {
  description = "Initial database name created in the RDS instance"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "backup_retention_days" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the RDS instance"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the DB instance is deleted"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to RDS resources"
  type        = map(string)
  default     = {}
}
