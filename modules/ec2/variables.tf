variable "vpc_id" {
   type = string
}
variable "vpc_cidr" {
   type = string
}
variable "private_subnet_id" {
   type = list(string)
}
variable "public_subnet_id" {
   type = list(string)
}
variable "key_name" {
  type = string
}
variable "ebs_optimized" {
  type = string
  default = "false"
}
variable "disable_api_termination" {
  type = string
  default = "false"
}
variable "monitoring" {
  type = string
  default = "false"
}
variable "delete_on_termination" {
  type = string
  default = "true"
}
variable "root_volume_type" {
  type = string
  default = "gp2"
}
variable "root_volume_size" {
  type = number
  default = 8
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "environment" {
  type = string
}
variable "mongodb_ips" {
  type = list
}



