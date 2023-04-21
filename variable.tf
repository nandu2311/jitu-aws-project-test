variable "availability_zones" {
  description = "AZs in this region to use"
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  type        = list(any)
}

variable "subnet_cidrs_public" {
  description = "CIDRs of public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type        = list(any)
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_name" {
  default = "env-vpc"
}

variable "security_group_name" {
  default = "env-sg"
}

variable "s3_bucket_name" {
  default = "simple-website-testing-vpcendpoint"
}

variable "instance_name" {
  default = "env-instance"
}

variable "route53_name" {
  default = "nritworld.xyz"
}

variable "route53_record" {
  default = "appserver"
}

variable "ig" {
  default = "internet_gateway"
}

variable "key_pair_name" {
  default = "myvm"
}

variable "ami_id" {
  default = "ami-0f8ca728008ff5af4"
}


