resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = {
    Name = "cp-rtb-public-${var.env}"
  }
}
resource "aws_route_table_association" "public" {
  for_each       = toset(var.public_subnet_ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.network_interface_id
  }
  tags = {
    Name = "cp-rtb-private-${var.env}"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = toset(var.private_subnet_ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}
