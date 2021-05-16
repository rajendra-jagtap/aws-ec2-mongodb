environment                 = "dev"
region                      = "us-east-1"
bucket                      = "rajendra-devops"
key                         = "terraform/dev/cluster.tfstate"
vpc_cidr                    = "192.168.0.0/20"
public_subnets_cidr         = ["192.168.2.0/24","192.168.3.0/24"]
private_subnets_cidr        = ["192.168.0.0/24","192.168.1.0/24"]
availability_zones          = ["us-east-1c","us-east-1d"]

key_name                    = "raj-dev"
mongodb_ips                 = ["192.168.2.21","192.168.3.22","192.168.2.23"]
instance_type               = "t2.micro"
