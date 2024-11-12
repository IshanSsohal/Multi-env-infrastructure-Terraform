variable "environment" {
  description = "Environment name i.e. nonprod and prod"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = list(map(string))
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = list(map(string))
}
