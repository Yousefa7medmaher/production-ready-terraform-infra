variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days after which noncurrent (old) application version objects are permanently deleted"
  type        = number
  default     = 90
}

variable "noncurrent_version_transition_days" {
  description = "Number of days after which noncurrent application version objects transition to STANDARD_IA"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
