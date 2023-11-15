provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-06e4ca05d431835e9"
    instance_type = "t2.micro"
    key_name = "dpp"
}