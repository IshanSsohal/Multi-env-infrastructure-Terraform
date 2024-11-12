# Terraform AWS Provider Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "acs730-assignment-ishan"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}