# Add output variables
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "public_subnet_cidrs" {
  value = aws_subnet.public_subnets[*].cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}
