output "application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.this.name
}

output "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.name
}

output "environment_id" {
  description = "ID of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.id
}

output "endpoint_url" {
  description = "Endpoint (CNAME) of the environment's load balancer"
  value       = aws_elastic_beanstalk_environment.this.cname
}

output "load_balancers" {
  description = "Load balancer name(s) associated with the environment"
  value       = aws_elastic_beanstalk_environment.this.load_balancers
}

output "autoscaling_groups" {
  description = "Auto Scaling Group name(s) associated with the environment"
  value       = aws_elastic_beanstalk_environment.this.autoscaling_groups
}

output "solution_stack_name" {
  description = "Resolved solution stack name that was deployed"
  value       = data.aws_elastic_beanstalk_solution_stack.node.name
}
