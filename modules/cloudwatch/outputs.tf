output "log_group_name" {
  description = "Name of the CloudWatch log group for Elastic Beanstalk logs"
  value       = aws_cloudwatch_log_group.eb_logs.name
}

output "cpu_alarm_arn" {
  description = "ARN of the CPU utilization alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
}

output "health_alarm_arn" {
  description = "ARN of the ASG in-service-instance health alarm"
  value       = aws_cloudwatch_metric_alarm.asg_in_service_low.arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS alarm topic (null if not created)"
  value       = var.create_sns_topic ? aws_sns_topic.alarms[0].arn : null
}
