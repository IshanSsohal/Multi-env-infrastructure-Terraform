# VPC Peering Connection
resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = true

  tags = var.tags
}

# Route in Non-Prod Private Route Table to Prod VPC
resource "aws_route" "requester_private_to_accepter" {
  route_table_id            = var.requester_route_table_id
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Routes in Requester VPC
resource "aws_route" "requester_public_to_accepter" {
  route_table_id            = var.requester_public_route_table_id
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Routes in Accepter VPC
resource "aws_route" "accepter_to_requester" {
  route_table_id            = var.accepter_route_table_id
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
