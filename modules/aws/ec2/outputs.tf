output "id_nat" {
  value = aws_instance.cp_nat_1a.id
}

output "id_bastion" {
  value = aws_instance.cp_bastion.id
}

output "id_bastion_network_interface" {
  value = aws_instance.cp_bastion.primary_network_interface_id
}

output "id_nat_network_interface" {
  value = aws_instance.cp_nat_1a.primary_network_interface_id
}
