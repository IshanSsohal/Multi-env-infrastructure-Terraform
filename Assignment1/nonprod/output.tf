output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_cidrs" {
  value = module.network.public_subnet_cidrs
}

output "public_route_table_id" {
  value = module.network.public_route_table_id
}

output "private_route_table_id" {
  value = module.network.private_route_table_id
}

output "vpc_cidr_block" {
  value = module.network.vpc_cidr_block
}
