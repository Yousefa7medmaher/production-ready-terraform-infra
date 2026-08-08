project_name = "joo-lab"
environment  = "dev"
region       = "us-east-1"

azs = ["us-east-1a", "us-east-1b"]

vpc_cidr            = "10.0.0.0/16"
public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
private_app_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
private_db_subnets  = ["10.0.21.0/24", "10.0.22.0/24"]
single_nat_gateway  = true

# Tighten this to your office/VPN CIDR in real use; instances sit in
# private subnets, so this only matters if you have a bastion/VPN path in.
ssh_allowed_cidr = "10.0.0.0/16"

enable_db_security_group = true

db_port                = 5432
db_instance_identifier = "joo-lab-dev-db"
db_engine              = "postgres"
db_engine_version      = ""
db_instance_class      = "db.t3.micro"
allocated_storage      = 20
storage_type           = "gp3"
db_name                = "appdb"
db_username            = "appuser"
backup_retention_days  = 7
deletion_protection    = false
skip_final_snapshot    = true

enable_s3_gateway_endpoint = true

instance_type = "t3.micro"
min_instances = 2
max_instances = 4

healthcheck_path    = "/"
log_retention_days  = 30
cpu_alarm_threshold = 80

create_sns_topic = true
alarm_email      = "youssef230103838@sut.edu.eg"

tags = {
  Owner = "joo-lab-team"
}
