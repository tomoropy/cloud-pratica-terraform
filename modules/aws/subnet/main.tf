resource "aws_subnet" "public_1a" {
  vpc_id                  = var.vpc_id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a-${var.env}"
  }
}
resource "aws_subnet" "public_1c" {
  vpc_id                  = var.vpc_id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1c-${var.env}"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = var.vpc_id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.128.0/20"
  tags = {
    Name = "private-subnet-1a-${var.env}"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = var.vpc_id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.144.0/20"
  tags = {
    Name = "private-subnet-1c-${var.env}"
  }
}
