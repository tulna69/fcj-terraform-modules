provider "aws" {
    region = "us-east-1"
}

module "cloud9_environment" {
    source = "../../modules/developer-tools"
    name = var.name
}