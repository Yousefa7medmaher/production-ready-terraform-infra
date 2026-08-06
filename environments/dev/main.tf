############################################
# joo-lab - dev environment
# Wires together all reusable modules.
############################################

locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

############################################
# Networking
############################################

module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnets       = var.public_subnets
  private_app_subnets  = var.private_app_subnets
  private_db_subnets   = var.private_db_subnets
  single_nat_gateway   = var.single_nat_gateway
  tags                 = local.common_tags
}

############################################
# Security Groups
############################################

module "security" {
  source = "../../modules/security"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  ssh_allowed_cidr          = var.ssh_allowed_cidr
  enable_db_security_group  = var.enable_db_security_group
  tags                      = local.common_tags
}

############################################
# IAM
############################################

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

############################################
# S3 (application versions bucket)
############################################

module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

############################################
# Elastic Beanstalk
############################################

module "elastic_beanstalk" {
  source = "../../modules/elastic-beanstalk"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.networking.vpc_id
  public_subnet_ids       = module.networking.public_subnet_ids
  private_app_subnet_ids  = module.networking.private_app_subnet_ids
  alb_security_group_id   = module.security.alb_security_group_id
  ec2_security_group_id   = module.security.ec2_security_group_id
  instance_profile_name   = module.iam.instance_profile_name
  service_role_arn        = module.iam.eb_service_role_arn
  instance_type            = var.instance_type
  min_instances            = var.min_instances
  max_instances            = var.max_instances
  healthcheck_path         = var.healthcheck_path
  log_retention_days       = var.log_retention_days
  tags                     = local.common_tags
}

############################################
# CloudWatch (alarms depend on the ASG that EB creates)
############################################

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project_name             = var.project_name
  environment              = var.environment
  autoscaling_group_name   = try(element(module.elastic_beanstalk.autoscaling_groups, 0), "")
  min_instances            = var.min_instances
  log_retention_days       = var.log_retention_days
  cpu_alarm_threshold      = var.cpu_alarm_threshold
  create_sns_topic         = var.create_sns_topic
  alarm_email              = var.alarm_email
  tags                     = local.common_tags
}
