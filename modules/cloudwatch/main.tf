
# CloudWatch Module - joo-lab
# Log group, alarms, and optional SNS notifications.


locals {
  name_prefix = "${var.project_name}-${var.environment}"
}


# Log Group
# Elastic Beanstalk streams instance logs here when
# aws:elasticbeanstalk:cloudwatch:logs / StreamLogs is enabled.


resource "aws_cloudwatch_log_group" "eb_logs" {
  name              = "/aws/elasticbeanstalk/${local.name_prefix}/var/log/eb-engine.log"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-eb-log-group"
  })
}


# SNS Topic (optional) for alarm notifications


resource "aws_sns_topic" "alarms" {
  count = var.create_sns_topic ? 1 : 0
  name  = "${local.name_prefix}-alarms"

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-alarms"
  })
}

resource "aws_sns_topic_subscription" "alarm_email" {
  count     = var.create_sns_topic && var.alarm_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alarms[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

locals {
  alarm_actions = var.create_sns_topic ? [aws_sns_topic.alarms[0].arn] : []
}


# CPU Utilization Alarm
# Standard ASG-level CPU alarm.


resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${local.name_prefix}-cpu-high"
  alarm_description   = "Average CPU utilization across the Elastic Beanstalk Auto Scaling Group is too high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.alarm_actions

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-cpu-high"
  })
}


# ASG Health / "Status Check" Alarm
#
# NOTE: EC2's native StatusCheckFailed metric is published per-instance
# (dimension = InstanceId), not per Auto Scaling Group, so it cannot be
# aggregated directly onto an AutoScalingGroupName dimension. Elastic
# Beanstalk's Enhanced Health Reporting (enabled in the elastic-beanstalk
# module) already performs this per-instance status-check monitoring and
# feeds it into the EB console/health API.
#
# As a CloudWatch-native complement, this alarm watches the number of
# InService instances in the ASG and fires if it drops below the
# configured minimum, which is a reliable proxy for "instances are
# failing and not being replaced fast enough".


resource "aws_cloudwatch_metric_alarm" "asg_in_service_low" {
  alarm_name          = "${local.name_prefix}-asg-in-service-low"
  alarm_description   = "Number of healthy in-service instances has dropped below the configured minimum"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = 300
  statistic           = "Average"
  threshold           = var.min_instances
  treat_missing_data  = "breaching"

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.alarm_actions

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-asg-in-service-low"
  })
}
