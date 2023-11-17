
provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-06e4ca05d431835e9"
    instance_type = "t2.micro"
    key_name = "dpp"
    # security_groups = [ "demo-sg" ]
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.dpw-public_subnet_01.id
for_each = toset(["jenkins-master", "build-slave", "ansible"])
    tags = {
     Name = "${each.key}"
   }
}


resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.dpw-vpc.id
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-port"

  }
}
resource "aws_vpc" "dpw-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "dpw-vpc"
    }
}

resource "aws_subnet" "dpw-public_subnet_01" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1a"
    tags = {
        Name = "dpw-public_subnet_01"
    }
}
resource "aws_subnet" "dpw-public_subnet_02" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1c"
    tags = {
        Name = "dpw-public_subnet_02"
    }
}

resource "aws_internet_gateway" "dpw-igw" {
    vpc_id = aws_vpc.dpw-vpc.id
    tags = {
        Name = "dpw-igw"
    }
}

resource "aws_route_table" "dpw-public-rt" {
    vpc_id = aws_vpc.dpw-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpw-igw.id
    }
    tags = {
        Name = "dpw-public-rt"
    }
}

resource "aws_route_table_association" "dpw-rta-public-subnet-1" {
    subnet_id = aws_subnet.dpw-public_subnet_01.id
    route_table_id = aws_route_table.dpw-public-rt.id
}
