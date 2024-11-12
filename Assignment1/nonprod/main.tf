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
#     key    = "non-prod/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Data source for existing key pair for Bastion VM
data "aws_key_pair" "bastion_kp" {
  key_name = "bastion-kp"
}

# Data source for existing key pair for Private VMs
data "aws_key_pair" "private_vm_kp" {
  key_name = "private-vm-kp"
}

# Network Module
module "network" {
  source = "../../modules/network"

  vpc_cidr_block         = "10.1.0.0/16"
  public_subnet_cidrs    = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs   = ["10.1.3.0/24", "10.1.4.0/24"]
  availability_zones     = ["us-east-1a", "us-east-1b"]
  create_nat_gateway     = true
  environment            = "non-prod"
  tags                   = { Name = "non-prod"  }
  public_subnet_tags     = [
             { Name = "Public Subnet 1" },
             
          { Name = "Public Subnet 2" }
  ]
  private_subnet_tags    = [
          { Name = "Private Subnet 1" },
          
          
    { Name = "Private Subnet 2" }
  ]
}

# Webservers Module for Non-Prod VMs
module "non_prod_webservers" {
  source = "../../modules/webservers"

  vpc_id                    = module.network.vpc_id
  security_group_name       = "non-prod-sg"
  security_group_description = "Security group for non-prod EC2 instances"
  http_cidr_blocks          = [module.network.vpc_cidr_block]
  ssh_cidr_blocks           = [] # Will be set via SG rule
  create_sg_rule            = true
  sg_rule_type              = "ingress"
  sg_rule_from_port         = 22
  sg_rule_to_port           = 22
  sg_rule_protocol          = "tcp"
  source_security_group_id  = module.bastion.security_group_id
  sg_rule_description       = "Allow SSH from Bastion SG"

  instance_count            = 2
  ami                       = "ami-0ddc798b3f1a5117e"
  instance_type             = "t2.micro"
  subnet_ids                = module.network.private_subnet_ids
  key_name                  = data.aws_key_pair.private_vm_kp.key_name
  associate_public_ip       = false
  user_data                 = <<-EOF
                                #!/bin/bash
                                yum update -y
                                yum install -y httpd
                                INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                                echo "<html><body><h1>Ishan-$INSTANCE_IP-Non-Prod</h1></body></html>" > /var/www/html/index.html
                                sudo systemctl start httpd
                                sudo systemctl enable httpd
                                EOF
  tags                      = {
  
  Name = "non-prod" }
  instance_tags             = [
       {
    Name = "VM1"
    },
      { 
    Name = "VM2"
    }
  ]
}

# Webservers Module for Bastion VM
module "bastion" {
  source = "../../modules/webservers"

  vpc_id                    = module.network.vpc_id
  security_group_name       = "bastion-sg"
  security_group_description = "Security group for Bastion VM"
  http_cidr_blocks          = []
  ssh_cidr_blocks           = ["0.0.0.0/0"] # Replace with your IP range for security
  create_sg_rule            = false
  instance_count            = 1
  ami                       = "ami-0ddc798b3f1a5117e"
  instance_type             = "t2.micro"
  subnet_ids                = [module.network.public_subnet_ids[1]]
  key_name                  = data.aws_key_pair.bastion_kp.key_name
  associate_public_ip       = true
  user_data                 = ""
  tags                      = { Name = "non-prod" }
  instance_tags             = [
    { Name = "Bastion VM" }
  ]
}
