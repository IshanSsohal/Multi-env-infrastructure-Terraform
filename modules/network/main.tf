# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    var.tags,
    { Name = "${var.environment}-vpc" }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    { Name = "${var.environment}-igw" }
  )
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    { Name = "${var.environment}-public-rt" }
  )
}


# Public Subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = var.public_subnet_tags[count.index]
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(
    var.tags,
    { Name = "${var.environment}-nat-eip" }
  )
}


# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id #this will create nat gateway in public subnet1

  tags = merge(
    var.tags,
    { Name = "${var.environment}-natgw" }
  )
}


# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  
 
  tags = merge(
    var.tags,
    { Name = "${var.environment}-private-rt" }
  )
}

resource "aws_route" "private_default_route" {
  count = var.create_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = var.private_subnet_tags[count.index]
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
