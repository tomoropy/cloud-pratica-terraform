resource "aws_internet_gateway" "cloud_pratica" {
  vpc_id = var.vpc_id
  tags = {
    Name = "cp-igw-${var.env}"
  }
}
