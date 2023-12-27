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

###################################################################
# -- TODO: define your MODULE            
###################################################################
module "network" {
    source = "../network"
}

###################################################################
# -- TODO: define your DATA
###################################################################

###################################################################
# -- TODO: define your RESOURCE
###################################################################
resource "aws_db_instance" "this" {
    db_subnet_group_name = aws_db_subnet_group.this.name
    allocated_storage = 10
    engine               = "mysql"
    username             = "admin"
    password             = "123Vodanhphai"
    network_type         = "IPV4"
    vpc_security_group_ids = [module.network.db_security_group_id]
    instance_class       = "db.t3.micro"
    skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "this" {
    name = "fcj-management-subnet-group"
    description =  "Subnet Group for FCJ Management"

    subnet_ids = module.network.private_subnet_ids
}
