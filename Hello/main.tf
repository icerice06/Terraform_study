terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-2"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "simple_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "simple_vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.simple_vpc.id
  cidr_block = "10.0.0.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.simple_vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.simple_vpc.id
  tags = {
    Name = "simple_vpc_IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.simple_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.simple_vpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.simple_vpc.id
  cidr_block = "10.0.3.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_eip" "nat_ip" {
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id

  subnet_id = aws_subnet.public_subnet1.id

  tags = {
    Name = "NAT_gateway"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.simple_vpc.id

  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "private_rt_association1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route" "private_rt_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_security_group" "hello" {
  name   = "hello"
  vpc_id = aws_vpc.simple_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "hello" {
  ami                         = "ami-0e01e66dacaf1454d"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet1.id
  key_name                    = "wsi-keypair"
  vpc_security_group_ids      = [aws_security_group.hello.id]
  associate_public_ip_address = "true"
  user_data                   = file("${path.module}/hello.sh")
  # user_data                   = <<-EOS
  # #!/bin/bash

  # yum install -y httpd
  # systemctl enable --now httpd

  # echo "Hello, world!" > /var/www/html/index.html
  # EOS

  tags = {
    Name = "hello"
  }

}

/*
terraform init >> 테라폼 파일 생성
terraform plan >> 확인
terraform apply >> 실행
terraform destroy >> 올 삭제
aws configure  >> 자격증명 
*/
