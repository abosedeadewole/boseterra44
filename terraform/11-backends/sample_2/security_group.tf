
data "aws_vpc" "trial" {
  filter {
    name   = "tag:Name"
    values = ["trial"]
  }

  filter {
    name = "vpc-id"
    values = [ "vpc-0c22e61bb0e705fca" ]
  }

}

locals {
  ingress = [{
    description = "Allow HTTP Trafiic"
    port        = 8080
    protocol    = "tcp"
    },

    {
      description = "Allow SSH Trafiic"
      port        = 22
      protocol    = "tcp"
    },

    {
      description = "Allow TLS Trafiic"
      port        = 443
      protocol    = "tcp"
    }
  ]
  egress = [{
    description = "Allow HTTP Trafiic"
    port        = 8080
    protocol    = "tcp"
    },

    {
      description = "Allow SSH Trafiic"
      port        = 22
      protocol    = "tcp"
    },

    {
      description = "Allow TLS Trafiic"
      port        = 443
      protocol    = "tcp"
    }
  ]

}

resource "aws_subnet" "secondary_cidr" {
  vpc_id     = data.aws_vpc.trial.id
  cidr_block = "10.80.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
  
  tags = {
    "Name" = "Public Subnet"
  }
}

resource "aws_route_table" "route_table_new" {
  vpc_id = data.aws_vpc.trial.id
  
   /* route = [
    {
      cidr_block = "0.0.0.0"
      gateway_id = aws_internet_gateway.igw_trial.id
    }
  ] */

  tags = {
    Name = "route_table_new"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.secondary_cidr.id
  route_table_id = aws_route_table.route_table_new.id
}

resource "aws_route" "route2"  {
  route_table_id            = aws_route_table.route_table_new.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_trial.id
}
resource "aws_internet_gateway" "igw_trial" {
  vpc_id = data.aws_vpc.trial.id

  tags = {
    Name = "igw_trial"
  }
}


resource "aws_security_group" "cloudwalker" {
  name        = "cloudwalker_terraform"
  description = "Allow HTTP and TLS inbound traffic"
  vpc_id      = data.aws_vpc.trial.id

  dynamic "ingress" {
    for_each = local.ingress
    iterator = server_port
    content {
      description      = server_port.value.description
      from_port        = server_port.value.port
      to_port          = server_port.value.port
      protocol         = server_port.value.protocol
      cidr_blocks      = ["64.39.167.201/32"]
      ipv6_cidr_blocks = []
      self             = false
    }
  }

  egress = [ {
      description      = "allow allout going traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
  } ]
  
  
  tags = {
    Name = "cloudwalker_terraform"
  }

}
