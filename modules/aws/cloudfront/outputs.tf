output "arn_cloudfront_distribution" {
  value = aws_cloudfront_distribution.slack_metrics.arn
}

// バージニア北部リージョンのゾーンID(固定)
output "zone_id_us_east_1" {
  value = "Z2FDTNDATAQYW2"
}

output "domain_name_slack_metrics_client" {
  value = aws_cloudfront_distribution.slack_metrics.domain_name
}
