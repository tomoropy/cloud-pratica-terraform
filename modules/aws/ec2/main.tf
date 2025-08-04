resource "aws_instance" "cp_bastion" {
  ami                  = var.ami_id_amazon_linux
  iam_instance_profile = "cp-bastion-${var.env}"
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  source_dest_check    = false
  tags = {
    Name = "cp-bastion-${var.env}"
  }
  vpc_security_group_ids = var.bastion_security_group_ids
}

resource "aws_instance" "cp_nat_1a" {
  ami                  = var.ami_id_amazon_linux
  iam_instance_profile = "cp-nat-${var.env}"
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  source_dest_check    = false
  tags = {
    Name = "cp-nat-1a-${var.env}"
  }
  vpc_security_group_ids = var.nat_security_group_ids
}
