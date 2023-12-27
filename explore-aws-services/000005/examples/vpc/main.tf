variable "cidr" {
  type        = string
  description = "The cidr block of the vpc"
}

locals {
  azs = formatlist("${data.aws_region.current.name}%s", ["a", "b"])

  number_of_public_subnets  = 2
  number_of_private_subnets = 2
  number_of_subnets         = local.number_of_public_subnets + local.number_of_private_subnets
  cidrsubnet_newbits        = log(local.number_of_subnets, 2)
  public_subnets = [
    for idx in range(local.number_of_public_subnets) : cidrsubnet(var.cidr, local.cidrsubnet_newbits, idx)
  ]
  private_subnets = [
    for idx in range(local.number_of_private_subnets) : cidrsubnet(var.cidr, local.cidrsubnet_newbits, idx + local.number_of_public_subnets)
  ]
}

module "vpc" {
  source = "../../modules/vpc"

  env                  = "dev"
  cidr                 = var.cidr
  azs                  = local.azs
  public_subnets       = local.public_subnets
  private_subnets      = local.private_subnets
  enable_dns_hostnames = true
}
