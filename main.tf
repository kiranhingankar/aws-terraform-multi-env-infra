# Fetch the latest Amazon Linux AMI automatically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 1. Official Registry Module for VPC
module "vpc" {

  source = "./modules/vpc"

  cidr               = var.vpc_cidr
  public_subnet_cidr = var.subnet_cidr

  environment  = local.environment
  project_name = var.project_name
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id

  ingress_ports = var.ingress_ports

  environment  = local.environment
  project_name = var.project_name
}

module "ec2" {
  source = "./modules/ec2-instance"

  ami_id = data.aws_ami.ubuntu.id

  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_id

  security_group_ids = [
    module.security_group.sg_id
  ]

  environment  = local.environment
  project_name = var.project_name
}
