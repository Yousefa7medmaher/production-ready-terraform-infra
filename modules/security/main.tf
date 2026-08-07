
# Security Groups Module - joo-lab


locals {
  name_prefix = "${var.project_name}-${var.environment}"
}


# ALB Security Group
# Public facing: allows HTTP/HTTPS from the internet


resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for the Elastic Beanstalk Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from the internet"
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 80
  to_port             = 80
  ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS from the internet"
  cidr_ipv4          = "0.0.0.0/0"
  from_port          = 443
  to_port             = 443
  ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_outbound" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound traffic"
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol         = "-1"
}


# EC2 (Application) Security Group
# Private tier: only reachable from the ALB, plus a configurable SSH CIDR
# (SSH is only useful if instances end up with a bastion/VPN path into the
# private subnet; kept configurable rather than hardcoded to 0.0.0.0/0).


resource "aws_security_group" "ec2" {
  name        = "${local.name_prefix}-ec2-sg"
  description = "Security group for Elastic Beanstalk EC2 instances"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-ec2-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http_from_alb" {
  security_group_id           = aws_security_group.ec2.id
  description                 = "Allow HTTP from the ALB only"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  to_port                       = 80
  ip_protocol                   = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_ssh" {
  security_group_id = aws_security_group.ec2.id
  description       = "Allow SSH from the configured CIDR only"
  cidr_ipv4          = var.ssh_allowed_cidr
  from_port          = 22
  to_port             = 22
  ip_protocol         = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_outbound" {
  security_group_id = aws_security_group.ec2.id
  description       = "Allow all outbound traffic (NAT egress for updates, package downloads, etc.)"
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol         = "-1"
}


# Database Security Group (optional)
# Only reachable from the application tier.


resource "aws_security_group" "db" {
  count       = var.enable_db_security_group ? 1 : 0
  name        = "${local.name_prefix}-db-sg"
  description = "Security group for the database tier - allows access from the application tier only"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-db-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  count                        = var.enable_db_security_group ? 1 : 0
  security_group_id           = aws_security_group.db[0].id
  description                 = "Allow database access from the application security group only"
  referenced_security_group_id = aws_security_group.ec2.id
  from_port                    = var.db_port
  to_port                       = var.db_port
  ip_protocol                   = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db_all_outbound" {
  count              = var.enable_db_security_group ? 1 : 0
  security_group_id = aws_security_group.db[0].id
  description       = "Allow all outbound traffic"
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol         = "-1"
}

