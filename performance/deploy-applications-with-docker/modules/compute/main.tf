terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0, < 2.0.0"
}

# ###################################################################
# # -- TODO: define your LOCALS            
# ###################################################################

# ###################################################################
# # -- TODO: define your MODULE            
# ###################################################################
module "network" {
    source = "../network"
}

module "database" {
    source = "../database"
}

# ###################################################################
# # -- TODO: define your DATA
# ###################################################################

# ###################################################################
# # -- TODO: define your RESOURCE
# ###################################################################
resource "aws_instance" "this" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"
    subnet_id = module.network.public_subnet_id
    vpc_security_group_ids = [module.network.db_security_group_id]
    user_data = templatefile("${path.module}/user-data.sh", {
        db_address  = module.database.db_address
        db_port     = module.database.db_port
        db_name = module.database.db_name
        db_username = module.database.db_username
    })

    tags = {
        Name = "FCJ-Management"
    }
}