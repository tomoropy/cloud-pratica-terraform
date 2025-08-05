output "id_nat" {
  value = aws_instance.cp_nat_1a.id
}

output "id_bastion" {
  value = aws_instance.cp_bastion.id
}
