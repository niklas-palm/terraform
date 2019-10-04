/* 
Network setup using two AZs

Creates a VPC with and internet gate way and four subnets: 2 public and 2 private. 
One public and one private subnet in each AZ, in total using two AZs.
A NAT in each of the public subnets.
*/

# Crete VPC

resource "aws_vpc" "TerraformVPC" {
  cidr_block = "10.0.0.0/16"
}

# Create IGW

resource "aws_internet_gateway" "main-igw" {
  vpc_id = "${aws_vpc.TerraformVPC.id}"

  tags = {
    Name = "main-igw"
  }
}

# Create Subnets

resource "aws_subnet" "pubsub_A" {
  vpc_id     = "${aws_vpc.TerraformVPC.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "pubsub_A"
  }
}

resource "aws_subnet" "pubsub_B" {
  vpc_id     = "${aws_vpc.TerraformVPC.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "pubsub_B"
  }
}

resource "aws_subnet" "privsub_A" {
  vpc_id     = "${aws_vpc.TerraformVPC.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "privsub_A"
  }
}

resource "aws_subnet" "privsub_B" {
  vpc_id     = "${aws_vpc.TerraformVPC.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "privsub_B"
  }
}

# Create NAT
# 1

resource "aws_eip" "nat_eip_1" {
    vpc = true
    tags = {
      Name = "nat_eip_1"
    }
}

resource "aws_nat_gateway" "NAT_A" {    
    allocation_id = "${aws_eip.nat_eip_1.id}"
    subnet_id = "${aws_subnet.pubsub_A.id}"
    depends_on = ["aws_internet_gateway.main-igw"]
}

# 2

resource "aws_eip" "nat_eip_2" {
    vpc = true
    tags = {
      Name = "nat_eip_2"
    }
}

resource "aws_nat_gateway" "NAT_B" {    
    allocation_id = "${aws_eip.nat_eip_2.id}"
    subnet_id = "${aws_subnet.pubsub_B.id}"
    depends_on = ["aws_internet_gateway.main-igw"]
}

# Create route tables and associations
# 1

resource "aws_route_table" "routeTable_pub_A" {
  vpc_id = "${aws_vpc.TerraformVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-igw.id}"
  }

  tags = {
    Name = "routeTable_pub_A"
  }
}

resource "aws_route_table_association" "Pub_A_routeRef" {
  subnet_id      = "${aws_subnet.pubsub_A.id}"
  route_table_id = "${aws_route_table.routeTable_pub_A.id}"
}

# 2

resource "aws_route_table" "routeTable_pub_B" {
  vpc_id = "${aws_vpc.TerraformVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-igw.id}"
  }

  tags = {
    Name = "routeTable_pub_B"
  }
}

resource "aws_route_table_association" "Pub_B_routeRef" {
  subnet_id      = "${aws_subnet.pubsub_B.id}"
  route_table_id = "${aws_route_table.routeTable_pub_B.id}"
}

# 3

resource "aws_route_table" "routeTable_priv_A" {
  vpc_id = "${aws_vpc.TerraformVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.NAT_A.id}"
  }

  tags = {
    Name = "routeTable_priv_A"
  }
}

resource "aws_route_table_association" "Priv_A_routeRef" {
  subnet_id      = "${aws_subnet.privsub_A.id}"
  route_table_id = "${aws_route_table.routeTable_priv_A.id}"
}

# 4

resource "aws_route_table" "routeTable_priv_B" {
  vpc_id = "${aws_vpc.TerraformVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.NAT_B.id}"
  }

  tags = {
    Name = "routeTable_priv_B"
  }
}

resource "aws_route_table_association" "Priv_B_routeRef" {
  subnet_id      = "${aws_subnet.privsub_B.id}"
  route_table_id = "${aws_route_table.routeTable_priv_B.id}"
}