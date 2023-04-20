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