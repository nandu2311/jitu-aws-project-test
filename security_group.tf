
#Create VPC 
resource "aws_vpc" "test-env" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "test-subnet" {
  vpc_id            = aws_vpc.test-env.id
  count             = length(var.subnet_cidrs_public)
  cidr_block        = var.subnet_cidrs_public[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    "Name" = var.availability_zones[count.index]
  }

}

#Create Internet Gateway
resource "aws_internet_gateway" "test_internet_gateway" {
  vpc_id = aws_vpc.test-env.id
  tags = {
    "Name" = var.ig
  }
}

#Create Route table and attached internet gateway
resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.test-env.id
  /* count = length(var.subnet_cidrs_public)
  subnet_id = aws_subnet.test-subnet[count.index] */

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_internet_gateway.id
  }
  
  /* route {
    cidr_block = data.aws_prefix_list.vpce_prefix_list.cidr_blocks[0]
    vpc_endpoint_id = aws_vpc_endpoint.s3.id
  } */

}

#create Main route table association
/* resource "aws_main_route_table_association" "test_route_table_association" {
  count          = length(var.subnet_cidrs_public)
  vpc_id         = aws_vpc.test-env.id
  route_table_id = aws_route_table.test_route_table.id
  
} */

resource "aws_route_table_association" "route_table_association" {
    count = length(var.subnet_cidrs_public)
    /* vpc_id = aws_vpc.test-env.id */
    subnet_id = aws_subnet.test-subnet[count.index].id
    route_table_id = aws_route_table.test_route_table.id
    
}


#Create Security Group for test
resource "aws_security_group" "test_security_group" {
  name        = var.security_group_name
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.test-env.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_subnet.test-subnet
  ]

  tags = {
    name = var.security_group_name
  }

}

