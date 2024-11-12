output "vpc_id" {
  value = module.network.vpc_id
}

output "private_route_table_id" {
  value = module.network.private_route_table_id
}

output "vpc_cidr_block" {
  value = module.network.vpc_cidr_block
}
