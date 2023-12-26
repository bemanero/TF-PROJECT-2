#VPC creation
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = true
  tags = {
    Name = var.project_name
  }
}

data "aws_availability_zones" "avz" {
  exclude_names = [var.exclude_names]
}


resource "aws_subnet" "subnet" {
  count             = length(var.subnet_names)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block[count.index]
  availability_zone = element(data.aws_availability_zones.avz.names, count.index)
  tags              = { name = "${var.subnet_names[count.index]}" }

  depends_on = [aws_vpc.vpc]
}


resource "aws_internet_gateway" "gw" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]

}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet[0].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = var.vpc_cidr
    gateway_id = var.local_access
  }
  route {
    cidr_block = var.public_access
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = var.vpc_cidr
    gateway_id = var.local_access
  }
  route {
    cidr_block = var.public_access
    gateway_id = aws_nat_gateway.nat_gw.id
  }
}
resource "aws_route_table_association" "public_route_a" {

  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public_route_b" {

  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private_route_a" {
  subnet_id      = aws_subnet.subnet[2].id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "private_route_b" {

  subnet_id      = aws_subnet.subnet[3].id
  route_table_id = aws_route_table.private-rt.id
}
# Key pair
resource "tls_private_key" "t2_private_key" {
  algorithm = "ED25519"
}
resource "aws_key_pair" "t2_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.t2_private_key.public_key_openssh
}
# Security Groups
locals {
  inbound_port  = [80, 22]
  outbound_port = [0, 0]
}

resource "aws_security_group" "sg-server" {
  vpc_id      = aws_vpc.vpc.id
  name        = "servers"
  description = "Security Group for Web Servers"

  dynamic "ingress" {
    for_each = local.inbound_port

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  }

  dynamic "egress" {
    for_each = local.outbound_port

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = [var.public_access]
    }
  }
}
#Servers
module "servers" {

  source                = "./modules/server"
  count                 = length(var.servername)
  instance_type         = var.instance_type
  security_group_server = aws_security_group.sg-server.id
  vpc_id                = aws_vpc.vpc.id
  subnet_id             = aws_subnet.subnet[count.index].id
  depends_on            = [aws_vpc.vpc]
  key_name              = aws_key_pair.t2_key_pair.key_name
  tags = {
    name = "${var.servername[count.index]}"
  }
}
locals {
  inbound_ports  = [3306, 80, 22]
  outbound_ports = [0, 0, 0]
}
resource "aws_security_group" "sg-db" {
  vpc_id      = aws_vpc.vpc.id
  name        = "db"
  description = "Security Group for db"

  dynamic "ingress" {
    for_each = local.inbound_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.ingress-protocol
      cidr_blocks = [var.public_access]
    }
  }

  dynamic "egress" {
    for_each = local.outbound_ports

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = var.egress-protocol
      cidr_blocks = [var.vpc_cidr]
    }
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id, aws_subnet.subnet[2].id, aws_subnet.subnet[3].id]

  tags = {
    Name = "T2 DB subnet group"
  }
}

module "rds" {
  source               = "./modules/db"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_cidr_block       = var.vpc_cidr
  db_sg                = aws_security_group.sg-db.id
}




