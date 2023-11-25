variable "ami" {
    default = "ami-0cbd40f694b804622"
  
}

variable "instance_type" {
    default = "t2.micro"
  
}

variable "key" {

    default = "dpp"
  
}

variable "vpc" {

    default = "10.2.0.0/16"
  
}

variable "subnet" {

    default = "10.2.2.0/24"
  
}

variable "subnet2" {

    default = "10.2.3.0/24"
  
}
