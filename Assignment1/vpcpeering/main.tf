# # Terraform AWS Provider Configuration
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }

#   backend "s3" {
#     bucket = "acs730-assignment-ishan"
#     key    = "vpcpeering/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Access Remote State of Non-Prod Environment
data "terraform_remote_state" "non_prod" {
  backend = "s3"

  config = {
    bucket = "acs730-assignment-ishan"
    key    = "non-prod/terraform.tfstate"
    region = "us-east-1"
  }
}

# Access Remote State of Prod Environment
data "terraform_remote_state" "prod" {
  backend = "s3"

  config = {
    bucket = "acs730-assignment-ishan"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

# Peering Module
module "peering" {
  source = "../../modules/peering"

  requester_vpc_id        = data.terraform_remote_state.non_prod.outputs.vpc_id
  accepter_vpc_id         = data.terraform_remote_state.prod.outputs.vpc_id
  requester_route_table_id = data.terraform_remote_state.non_prod.outputs.private_route_table_id
  accepter_route_table_id  = data.terraform_remote_state.prod.outputs.private_route_table_id
  requester_public_route_table_id  = data.terraform_remote_state.non_prod.outputs.public_route_table_id
  requester_vpc_cidr      = data.terraform_remote_state.non_prod.outputs.vpc_cidr_block
  accepter_vpc_cidr       = data.terraform_remote_state.prod.outputs.vpc_cidr_block
  tags                    = { Name = "non-prod-to-prod" }
}
