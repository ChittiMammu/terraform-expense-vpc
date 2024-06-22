### vpc creation code

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
  }

#### igw code

  resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.aws_internet_gateway,
    {
      Name = "gw"
    }
  )
}


### subnet creation

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  availability_zone = local.availability_zones[count.index]
    map_public_ip_on_launch = true
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = merge(
    
var.common_tags,
var.public_subnet_cidr_tags,
{

Name = "${local.resource_name}-public-${local.availability_zones[count.index]}"

  }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  availability_zone = local.availability_zones[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(
    
var.common_tags,
var.private_subnet_cidr_tags,
{

Name = "${local.resource_name}-private-${local.availability_zones[count.index]}"

  }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  availability_zone = local.availability_zones[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(
    
var.common_tags,
var.database_subnet_cidr_tags,
{

Name = "${local.resource_name}-database-${local.availability_zones[count.index]}"

  }
  )
}

### elastic IP

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "aws_eip"
  }
}

### creating NAT gateway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    
var.common_tags,
var.nat_gateway_tags,
{

Name = "${local.resource_name}"
  }
  )

  depends_on = [aws_internet_gateway.gw] ### natgate ways will pass the internet to private subnets through
  ### public subnets bec public subnets has the internet gate way connection.
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

   tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
        Name = "${local.resource_name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

   tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
        Name = "${local.resource_name}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

   tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
        Name = "${local.resource_name}-database"
    }
  )
}

### creating routs

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "private_route_nat" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database_route_nat" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

#### route table association with subnets

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}

# vpc
# igw
# associated vpc with igw
# 3 subnets
# elastic ip 
# NAT gateway
# route tables
# routs add
# routs association with subnets
# vpc peering
