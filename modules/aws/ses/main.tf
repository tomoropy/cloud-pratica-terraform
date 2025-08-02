resource "aws_sesv2_email_identity" "tomoropy" {
  email_identity = "${var.env}.${var.domain}"
}

resource "aws_sesv2_email_identity_mail_from_attributes" "tomoropy" {
  email_identity         = aws_sesv2_email_identity.tomoropy.id
  behavior_on_mx_failure = "USE_DEFAULT_VALUE"
  mail_from_domain       = "mail.${var.env}.${var.domain}"
}
