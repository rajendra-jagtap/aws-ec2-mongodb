#########################################################
# S3 Backend
#########################################################

terraform {
  backend "s3" {
    bucket = "var.bucket"
    key    = "var.key"
    region = "var.region"
   }
}

data "aws_caller_identity" "current" {}

#########################################################
# Network Module
#########################################################

module "networking" {
  source                = "./modules/network/"
  region                = "${var.region}"
  environment           = "${var.environment}"
  vpc_cidr              = "${var.vpc_cidr}"
  public_subnets_cidr   = "${var.public_subnets_cidr}"
  private_subnets_cidr  = "${var.private_subnets_cidr}"
  availability_zones    = "${var.availability_zones}"
}

#########################################################
# EC2 Modulle
#########################################################

module "ec2" {
  source                 = "./modules/ec2/"
  environment            = "${var.environment}"
  vpc_id                 = module.networking.vpc_id
  key_name               = "${var.key_name}"
  private_subnet_id      = module.networking.private_subnet_id
  public_subnet_id       = module.networking.public_subnet_id
  mongodb_ips            = "${var.mongodb_ips}"
  vpc_cidr               = "${var.vpc_cidr}"
  instance_type          = "${var.instance_type}"
}

#########################################################
# Ansible Resources
#########################################################

resource "ansible_host" "mongodb" {
  count                 = length(var.mongodb_ips)
  inventory_hostname    = module.ec2.mongodb_public_ip[count.index]
  groups                = ["mongodb"]
  vars = {
    ansible_user        = "ec2-user"
    become              = "yes"
    interpreter_python  = "/usr/bin/python2"
  }
}

