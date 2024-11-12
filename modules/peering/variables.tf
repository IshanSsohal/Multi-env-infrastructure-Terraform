variable "requester_vpc_id" {
  description = "VPC ID of the requester"
  type        = string
}

variable "accepter_vpc_id" {
  description = "VPC ID of the accepter"
  type        = string
}

variable "requester_public_route_table_id" {
  description = "public route table ID in the requester VPC"
  type        = string
}

variable "requester_route_table_id" {
  description = "Private route table ID in the requester VPC (non-prod)"
  type        = string
}

variable "accepter_route_table_id" {
  description = "private route table ID in the accepter VPC (prod)"
  type        = string
}

variable "requester_vpc_cidr" {
  description = "CIDR block of the requester VPC"
  type        = string
}

variable "accepter_vpc_cidr" {
  description = "CIDR block of the accepter VPC"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
