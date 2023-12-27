terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0, < 2.0.0"
}

###################################################################
# -- TODO: define your LOCALS            
###################################################################
locals {
  vpc_cidr_block = "10.0.0.0/16"

  number_of_private_subnets = 2
  number_of_public_subnets = 2
  number_of_subnets = local.number_of_public_subnets + local.number_of_private_subnets
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)

  tcp_protocol = "tcp"
  
  ssh_port = 22
  http_port    = 80
  https_port = 443
  custom_tcp_port = 5000
  db_port = 3306
  any_port     = 0

  all_ips      = "0.0.0.0/0"
}

###################################################################
# -- TODO: define your DATA            
###################################################################
data "aws_availability_zones" "available" {
  state = "available"
}

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

###################################################################
# -- TODO: define your RESOURCE            
###################################################################
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "container-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.all_ips
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public" {
  count = local.number_of_public_subnets
  vpc_id     = aws_vpc.main.id
  availability_zone = local.availability_zones[count.index]
  cidr_block = cidrsubnet(local.vpc_cidr_block, log(local.number_of_subnets, 2), count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = local.number_of_private_subnets
  vpc_id     = aws_vpc.main.id
  availability_zone = local.availability_zones[count.index]
  cidr_block = cidrsubnet(local.vpc_cidr_block, log(local.number_of_subnets, 2), count.index + 2)
}

#-------------------------------------------------
# -- TODO: define Security Group for EC2 instance
#-------------------------------------------------
resource "aws_security_group" "for_ec2_instance" {
  name = "FCJ-Management-SG"
  description = "Security Group for FCJ Management"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "for_ec2_instance"
  }
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.for_ec2_instance.id

  from_port   = local.ssh_port
  to_port     = local.ssh_port
  protocol    = local.tcp_protocol
  cidr_blocks = ["${chomp(data.http.my_public_ip.body)}/32"]
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.for_ec2_instance.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ips]
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.for_ec2_instance.id

  from_port   = local.https_port
  to_port     = local.https_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ips]
}

resource "aws_security_group_rule" "allow_custom_tpc_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.for_ec2_instance.id

  from_port   = local.custom_tcp_port
  to_port     = local.custom_tcp_port
  protocol    = local.tcp_protocol
  cidr_blocks = [local.all_ips]
}

#-------------------------------------------------
# -- TODO: define Security Group for RDS instance
#-------------------------------------------------
resource "aws_security_group" "for_rds_instance" {
  name = "FCJ-Management-DB-SG"
  description = "Security Group for DB instance"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "for_rds_instance"
  }
}

resource "aws_security_group_rule" "allow_db_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.for_rds_instance.id

  from_port   = local.db_port
  to_port     = local.db_port
  protocol    = local.tcp_protocol
  source_security_group_id = aws_security_group.for_ec2_instance.id
}