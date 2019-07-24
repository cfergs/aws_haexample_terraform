provider "aws" {
  region                  = "ap-southeast-2"
  shared_credentials_file = "./credentials"
  profile                 = "terraform"
}

resource "aws_vpc" "main" {
  cidr_block  = "10.200.0.0/20"

  tags = {
    Name = "VPC1"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id      = "${aws_vpc.main.id}"
  cidr_block  = "10.200.0.0/24"

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id      = "${aws_vpc.main.id}"
  cidr_block  = "10.200.2.0/23"

  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id  = "${aws_vpc.main.id}"

  tags = {
    Name = "IGW 1"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id  = "${aws_vpc.main.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id       = "${aws_subnet.public_subnet.id}"
  route_table_id  = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table" "private_route_table" {
  vpc_id  = "${aws_vpc.main.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = "${aws_nat_gateway.nat_gw.id}"
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id       = "${aws_subnet.private_subnet.id}"
  route_table_id  = "${aws_route_table.private_route_table.id}"
}

resource "aws_security_group" "WebServerSG" {
  name          = "Web Server SG"
  description   = "Security group for the web servers"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ConfigServerSG" {
  name          = "Config Server SG"
  description   = "Security group for the web servers"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}
