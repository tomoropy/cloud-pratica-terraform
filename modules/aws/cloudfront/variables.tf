// MEMO: AWSで設定されるグローバルな固定値
locals {
  cache_policy_id = {
    caching_optimized = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    caching_disabled  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }
  origin_request_policy_id = {
    all_viewer_except_host_header = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }
}
