data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "000005-tf-state"
    key    = var.networking_remote_state_key
    region = "us-east-1"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [terraform_remote_state.networking.outputs.vpc_id]
  }

  tags = {
    Tier = "Private"
  }
}
