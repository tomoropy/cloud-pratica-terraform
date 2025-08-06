// 東京リージョンのゾーンID(固定)
output "zone_id_ap_northeast_1" {
  value = "Z14GRHDCWA56QT"
}

output "alb_dns_name_tomoropy_com" {
  value = aws_lb.cp_alb.dns_name
}
