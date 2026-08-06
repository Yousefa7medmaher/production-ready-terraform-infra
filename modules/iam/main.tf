############################################
# IAM Module - joo-lab
# Elastic Beanstalk Service Role, EC2 Role,
# and Instance Profile.
############################################

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

############################################
# Elastic Beanstalk Service Role
# Assumed by the Elastic Beanstalk service itself to manage
# resources (ASG, ELB, CloudWatch) on your behalf.
############################################

data "aws_iam_policy_document" "eb_service_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["elasticbeanstalk"]
    }
  }
}

resource "aws_iam_role" "eb_service_role" {
  name               = "${local.name_prefix}-eb-service-role"
  assume_role_policy = data.aws_iam_policy_document.eb_service_assume_role.json

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-eb-service-role"
  })
}

resource "aws_iam_role_policy_attachment" "eb_service_enhanced_health" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "eb_service_managed_updates" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

############################################
# Elastic Beanstalk EC2 Role
# Assumed by the EC2 instances running the application. Grants
# the permissions the EB agent needs to pull app versions, ship
# logs/metrics, and (optionally) act as a worker tier consumer.
############################################

data "aws_iam_policy_document" "eb_ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eb_ec2_role" {
  name               = "${local.name_prefix}-eb-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.eb_ec2_assume_role.json

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-eb-ec2-role"
  })
}

resource "aws_iam_role_policy_attachment" "eb_ec2_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "eb_ec2_multicontainer_docker" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "${local.name_prefix}-eb-ec2-instance-profile"
  role = aws_iam_role.eb_ec2_role.name

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-eb-ec2-instance-profile"
  })
}
