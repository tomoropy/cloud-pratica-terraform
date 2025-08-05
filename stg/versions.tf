terraform {
  required_version = "~> 1.11.0" // 1.11.0 以上 1.12.0 未満 を許容

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2.0" // 6.2.0 以上 6.3.0 未満 を許容
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "cp-terraform-stg"

  default_tags {
    tags = {
      Env = "stg"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "cp-terraform-stg"
  alias   = "us_east_1"

  default_tags {
    tags = {
      Env = "stg"
    }
  }
}

# provider "datadog" {
#   api_key = local.datadog_key.api_key
#   app_key = local.datadog_key.app_key
#   api_url = "https://${local.datadog_site}"
# }
