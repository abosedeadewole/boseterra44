################################################################################
# VPC
################################################################################
resource "aws_vpc" "metadata_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Owner       = "user"
    Environment = "staging"
    Name = "metadata_vpc"
  }
}

resource "aws_internet_gateway" "metadata_vpc_igw" {
  vpc_id = aws_vpc.metadata_vpc.id
  tags = {
    Name = "metadata_vpc_igw"
  }
}

resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.metadata_vpc.id
  cidr_block              = var.Public_subnets_cidr
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone_public
  tags = {
    Name = "metadata_vpc_public_subnet"
  }
}
resource "aws_subnet" "private_sub" {
  vpc_id                  = aws_vpc.metadata_vpc.id
  cidr_block              = var.Private_subnets_cidr
  availability_zone       = var.availability_zone_private
  tags = {
    Name = "metadata_vpc_private_subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.metadata_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.metadata_vpc_igw.id
  }
  tags = {
    Name = "metadata_public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.metadata_vpc.id
  tags = {
    Name = "metadata_private_rt"
  }
}

resource "aws_route_table_association" "public_association_rt" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_association_rt" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private_rt.id
}


output "vpc_id" {
  value = aws_vpc.metadata_vpc.id
}


output "private_subnet_az" {
  value = aws_subnet.private_sub.availability_zone
}

output "private_subnet" {
 value = aws_subnet.private_sub.id
}
output "route_table" {
  value = aws_route_table.private_rt.id
}

output "public_subnet" {
 value = aws_subnet.public_sub.id
}