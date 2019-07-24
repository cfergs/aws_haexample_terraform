#Create VPC and the IGW
resource "aws_vpc" "main" {
  cidr_block  = "10.200.0.0/20"

  tags = {
    Name = "VPC1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id  = "${aws_vpc.main.id}"

  tags = {
    Name = "IGW 1"
  }
}

/*
## Create Public and Private networking infrastructure for each availability zone. 
## Values come in as variables from variables.tf
*/

resource "aws_subnet" "public_subnet" {
  count       = "${length(var.zones)}"
  vpc_id      = "${aws_vpc.main.id}"
  cidr_block  = "${var.zones[count.index].public_subnet}"
  availability_zone_id = "${data.aws_availability_zones.available.zone_ids[count.index]}"

  tags = {
    Name = "public-${var.zones[count.index].name}"
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
  count           = "${length(var.zones)}"
  subnet_id       = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id  = "${aws_route_table.public_route_table.id}"
}

/*
Lastly The private Subnet browses internet via a NAT gateway created in the public subnet 
We will create that and then create the private subnets
*/

resource "aws_eip" "nat" {
  count = "${length(var.zones)}"
  vpc   = true

  tags  = {
    Name = "eip-${var.zones[count.index].name}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = "${length(var.zones)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"

  tags = {
    Name = "natgw-${var.zones[count.index].name}"
  }
}

resource "aws_subnet" "private_subnet" {
  count       = "${length(var.zones)}"
  vpc_id      = "${aws_vpc.main.id}"
  cidr_block  = "${var.zones[count.index].private_subnet}"
  availability_zone_id = "${data.aws_availability_zones.available.zone_ids[count.index]}"

  tags = {
    Name = "private-${var.zones[count.index].name}"
  }
}

resource "aws_route_table" "private_route_table" {
  count   = "${length(var.zones)}"
  vpc_id  = "${aws_vpc.main.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = "${element(aws_nat_gateway.nat_gw.*.id, count.index)}"
  }

  tags = {
    Name = "prv_rt_tbl-${var.zones[count.index].name}"
  }
}

resource "aws_route_table_association" "private_route_association" {
  count           = "${length(var.zones)}"
  subnet_id       = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id  = "${element(aws_route_table.private_route_table.*.id, count.index)}"
}