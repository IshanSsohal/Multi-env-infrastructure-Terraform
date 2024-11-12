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
#     key    = "prod/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

data "terraform_remote_state" "non_prod" {
  backend = "s3"

  config = {
    bucket = "acs730-assignment-ishan"
    key    = "non-prod/terraform.tfstate"
    region = "us-east-1"
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Data source for existing key pair for Private VMs
data "aws_key_pair" "private_vm_kp" {
  key_name = "private-vm-kp"
}

# Network Module
module "network" {
  source = "../../modules/network"

  vpc_cidr_block         = "10.10.0.0/16"
  public_subnet_cidrs    = []
  private_subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
  availability_zones     = ["us-east-1a", "us-east-1b"]
  create_nat_gateway     = false
  environment           = "prod"
  tags                   = { Name = "prod" }
  public_subnet_tags     = []
  private_subnet_tags    = [
    { Name = "Private Subnet 3" },
    { Name = "Private Subnet 4" }
  ]
}

# Webservers Module for Prod VMs
module "prod_webservers" {
  source = "../../modules/webservers"

  vpc_id                    = module.network.vpc_id
  security_group_name       = "prod-sg"
  security_group_description = "Security group for prod EC2 instances"
  http_cidr_blocks          = []
  ssh_cidr_blocks           = [data.terraform_remote_state.non_prod.outputs.public_subnet_cidrs[1]] # Allow SSH from within VPC

  instance_count            = 2
  ami                       = "ami-0ddc798b3f1a5117e"
  instance_type             = "t2.micro"
  subnet_ids                = module.network.private_subnet_ids
  key_name                  = data.aws_key_pair.private_vm_kp.key_name
  associate_public_ip       = false
  user_data                 = ""
  tags                      = { Name = "prod" }
  instance_tags             = [
    { Name = "VM3" },
    { Name = "VM4" }
  ]
}
