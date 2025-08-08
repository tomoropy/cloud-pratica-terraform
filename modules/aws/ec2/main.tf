resource "aws_instance" "cp_bastion" {
  ami                  = var.bastion.ami_id
  iam_instance_profile = var.bastion.iam_instance_profile
  instance_type        = var.bastion.instance_type
  subnet_id            = var.public_subnet_id
  source_dest_check    = false
  tags = {
    Name = "cp-bastion-${var.env}"
  }
  vpc_security_group_ids = [var.bastion.security_group_id]
}

resource "aws_instance" "cp_nat_1a" {
  ami                  = var.nat_1a.ami_id
  iam_instance_profile = var.nat_1a.iam_instance_profile
  instance_type        = var.nat_1a.instance_type
  subnet_id            = var.public_subnet_id
  source_dest_check    = false
  tags = {
    Name = "cp-nat-1a-${var.env}"
  }
  vpc_security_group_ids = [var.nat_1a.security_group_id]
}
