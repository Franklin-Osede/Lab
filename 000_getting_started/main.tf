terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



provider "aws" {
  profile = default
  region  = "us-east-1"
}

resource "aws_instance" "my_server" {
  ami           = "ami-05576a079321f21f8"
  instance_type = "t2.micro"

  tags = {
    Name = "MyServer"
  }
}
