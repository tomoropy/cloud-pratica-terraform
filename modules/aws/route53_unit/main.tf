resource "aws_route53_zone" "tomoropy_com" {
  name = var.domain
}

resource "aws_route53_record" "record" {
  for_each = { for r in var.records : "${r.name}-${r.type}" => r }
  zone_id  = aws_route53_zone.tomoropy_com.zone_id
  name     = each.value.name
  type     = each.value.type
  ttl      = lookup(each.value, "ttl", null)
  records  = lookup(each.value, "values", null)
  dynamic "alias" {
    for_each = lookup(each.value, "alias", null) != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}

resource "aws_route53_record" "mail_env_tomoropy_com_TXT" {
  count   = var.ses.enable ? 1 : 0
  zone_id = aws_route53_zone.tomoropy_com.zone_id
  name    = "mail.${var.domain}"
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 include:amazonses.com ~all"]
}

resource "aws_route53_record" "mail_env_tomoropy_com_MX" {
  count   = var.ses.enable ? 1 : 0
  zone_id = aws_route53_zone.tomoropy_com.zone_id
  name    = "mail.${var.domain}"
  type    = "MX"
  ttl     = 300
  records = ["10 feedback-smtp.ap-northeast-1.amazonses.com"]
}

resource "aws_route53_record" "dmarc_TXT" {
  count   = var.ses.enable ? 1 : 0
  zone_id = aws_route53_zone.tomoropy_com.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 300
  records = ["v=DMARC1; p=none;"]
}

resource "aws_route53_record" "dkim_CNAME" {
  count   = var.ses.enable ? 3 : 0
  zone_id = aws_route53_zone.tomoropy_com.zone_id
  name    = "${var.ses.dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 1800
  records = ["${var.ses.dkim_tokens[count.index]}.dkim.amazonses.com"]
}
