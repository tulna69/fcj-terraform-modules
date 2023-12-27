# ---------------------------------------------------------------------------------------------------------------------
# LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  all_ips               = "0.0.0.0/0"
  create_public_subnets = length(var.public_subnets) > 0
}

# ---------------------------------------------------------------------------------------------------------------------
# RESOURCES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  count = local.create_public_subnets ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_route_table" "public" {
  count = local.create_public_subnets ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-rtb"
  }
}

resource "aws_route" "to_igw" {
  count = local.create_public_subnets ? 1 : 0

  route_table_id         = aws_route_table.main[0].id
  destination_cidr_block = local.all_ips
  gateway_id             = aws_internet_gateway.main[0].id
}

resource "aws_route_table_association" "public" {
  for_each = toset(aws_subnet.public)

  route_table_id = aws_route_table.public[0].id
  subnet_id      = each.key.id
}

resource "aws_subnet" "public" {
  for_each = {
    for idx, cidr in range(length(var.public_subnets)) : cidr => var.azs[idx % length(var.azs)]
  }

  vpc_id                  = aws_vpc.main.id
  availability_zone       = each.value
  cidr_block              = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-sn-${each.key}"
    Tier = "Public"
  }
}

resource "aws_subnet" "private" {
  for_each = {
    for idx, cidr in range(length(var.private_subnets)) : cidr => var.azs[idx % length(var.azs)]
  }

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value
  cidr_block        = each.key

  tags = {
    Name = "${var.env}-private-sn-${each.key}"
    Tier = "Private"
  }
}



# resource "aws_security_group" "for_rds" {
#   name        = "${var.env}-rds-sg"
#   description = "Security group for rds"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "${var.env}-rds-sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "rds_ingress" {
#   security_group_id = aws_security_group.for_rds.id

#   from_port                    = local.db_port
#   to_port                      = local.db_port
#   ip_protocol                  = local.tcp_protocol
#   referenced_security_group_id = aws_security_group.for_ec2.id
# }
