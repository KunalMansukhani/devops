
//creating a VPC
resource "aws_vpc" "dpp-vpc" {
    cidr_block = var.vpc
    tags = {
      Name = "dpp-vpc"
    }
  
}

// Creatomg a Subnet 
resource "aws_subnet" "dpp-public_subnet_01" {
  vpc_id = "${aws_vpc.dpp-vpc.id}"
    cidr_block = var.subnet
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1a"
    tags = {
      Name = "dpp-public_subnet_01"
    }
  
}

// Creatomg a Subnet 
resource "aws_subnet" "dpp-public_subnet_02" {
  vpc_id = "${aws_vpc.dpp-vpc.id}"
    cidr_block = var.subnet2
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1c"
    tags = {
      Name = "dpp-public_subnet_02"
    }
  
}

//Creating a Internet Gateway 
resource "aws_internet_gateway" "dpp-igw" {
    vpc_id = "${aws_vpc.dpp-vpc.id}"
    tags = {
      Name = "dpp-igw"
    }
}

// Create a route table 
resource "aws_route_table" "dpp-public-rt" {
    vpc_id = "${aws_vpc.dpp-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.dpp-igw.id}"
    }
    tags = {
      Name = "dpp-public-rt"
    }
}

// Associate subnet with routetable 

resource "aws_route_table_association" "dpp-rta-public-subnet-1" {
    subnet_id = "${aws_subnet.dpp-public_subnet_01.id}"
    route_table_id = "${aws_route_table.dpp-public-rt.id}"
  
}

resource "aws_route_table_association" "dpp-rta-public-subnet-2" {
    subnet_id = "${aws_subnet.dpp-public_subnet_02.id}"
    route_table_id = "${aws_route_table.dpp-public-rt.id}"
  
}

module "sgs" {
    source = "../sg_eks"
    vpc_id  =  aws_vpc.dpp-vpc.id
}

module "eks" {
   source = "../eks"
   vpc_id  =  aws_vpc.dpp-vpc.id
   subnet_ids = [aws_subnet.dpp-public_subnet_01.id,aws_subnet.dpp-public_subnet_02.id]
   sg_ids = module.sgs.security_group_public
}
