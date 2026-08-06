variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group created by Elastic Beanstalk (used as the alarm dimension)"
  type        = string
}

variable "min_instances" {
  description = "Minimum instance count for the environment; used as the threshold for the health alarm"
  type        = number
}

variable "log_retention_days" {
  description = "Retention period, in days, for the Elastic Beanstalk CloudWatch log group"
  type        = number
  default     = 30
}

variable "cpu_alarm_threshold" {
  description = "CPU utilization percentage that triggers the high-CPU alarm"
  type        = number
  default     = 80
}

variable "create_sns_topic" {
  description = "Whether to create an SNS topic for alarm notifications"
  type        = bool
  default     = true
}

variable "alarm_email" {
  description = "Optional email address to subscribe to the SNS alarm topic. Leave empty to skip the subscription."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
