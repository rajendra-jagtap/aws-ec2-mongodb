#############################################################
# data sources to get vpc, subnet, ami...
#############################################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name      = "name"
    values    = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name      = "owner-alias"
    values    = ["amazon"]
  }
}

#############################################################
# Create Security Group For EC2 Cluster
#############################################################

resource "aws_security_group" "mongodb-sg" {
  name              = "${var.environment}-mongodb-sg"
  description       = "Security group for EC2 Cluster"
  vpc_id            = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = 8
    to_port         = 0
    protocol        = "icmp"
    description     = "ping"
    cidr_blocks     = [var.vpc_cidr]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    description     = "ssh"
    cidr_blocks     = [var.vpc_cidr]
  }

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    description     = "mongo_port"
    cidr_blocks     = [var.vpc_cidr]
  }


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    description     = "ssh"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#############################################################
# Setup EC2 MongoDB Node's
#############################################################

resource "aws_instance" "mongodb" {
  ami                      = data.aws_ami.amazon_linux.id
  count                    = length(var.mongodb_ips)
  instance_type            = var.instance_type
  key_name                 = var.key_name
  ebs_optimized            = var.ebs_optimized
  vpc_security_group_ids   = [aws_security_group.mongodb-sg.id]
  subnet_id                = element(var.public_subnet_id, count.index)
#  subnet_id                = element(var.public_subnet_id)
# iam_instance_profile     = aws_iam_instance_profile.instance-profile.name
  private_ip               = var.mongodb_ips[count.index]
  disable_api_termination  = var.disable_api_termination
  monitoring               = var.monitoring
  lifecycle {
    ignore_changes         = [ami]
  }
  tags =  {
    Name                   = "${var.environment}-mongodb-node${count.index + 1}"
    Environment            = var.environment
  }
  root_block_device {
    volume_type            = var.root_volume_type
    volume_size            = var.root_volume_size
    delete_on_termination  = var.delete_on_termination
  }
}

#############################################################
# Output values to use in Ansible configuration
#############################################################

output "mongodb_public_ip" {
  value = "${aws_instance.mongodb.*.public_ip}"
}


