output "dkim_tokens_tomoropy" {
  value = aws_sesv2_email_identity.tomoropy.dkim_signing_attributes[0].tokens
}
