locals {
  vpc_cidr       = var.vpc_cidr
  subnet_public  = var.subnet_public
  subnet_private = var.subnet_private
}

data "aws_availability_zones" "available" {
  state = "available"
}

# vpc 
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    project = var.app_name
  }
}

# vpc igw
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    project = var.app_name
  }
}

# create subnets
resource "aws_subnet" "public" {
  for_each = {
    for k, v in local.subnet_public : k => v
    if local.subnet_public != [] # check if public subnets exist. If not - skip.
  }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.key]

  tags = {
    project = var.app_name
  }
}

resource "aws_subnet" "private" {
  for_each = {
    for k, v in local.subnet_private : k => v
  }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.key]

  tags = {
    project = var.app_name
  }
}

resource "aws_eip" "nat_gateway" {
  for_each = toset(local.subnet_public)
  vpc      = true
}

resource "aws_nat_gateway" "main" {
  for_each = {
    for k, v in local.subnet_private : k => v
  }
  allocation_id = tolist(values(aws_eip.nat_gateway))[each.key].id
  subnet_id     = tolist(values(aws_subnet.public))[each.key].id

  depends_on = [aws_internet_gateway.main]
  tags = {
    project = var.app_name
  }
}

# create route tables
resource "aws_route_table" "public" {
  for_each = toset(local.subnet_public)
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    project = var.app_name
  }
}

resource "aws_route_table" "private" {
  for_each = {
    for k, v in local.subnet_private : k => v
  }
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = tolist(values(aws_nat_gateway.main))[each.key].id
  }

  tags = {
    project = var.app_name
  }
}

# route table, subnet association
resource "aws_route_table_association" "public" {
  for_each = {
    for k, v in local.subnet_public : k => v
    if local.subnet_public != [] # check if public subnets exist. If not - skip
  }
  subnet_id      = tolist(values(aws_subnet.public))[each.key].id
  route_table_id = tolist(values(aws_route_table.public))[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for k, v in local.subnet_private : k => v
  }
  subnet_id      = tolist(values(aws_subnet.private))[each.key].id
  route_table_id = tolist(values(aws_route_table.private))[each.key].id
}

# creat vpc security group
resource "aws_security_group" "main" {
  name        = "allow_inbound_web_traffic"
  description = "allow inbound web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow TLS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project = var.app_name
  }
}


