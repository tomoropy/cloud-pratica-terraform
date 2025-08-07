terraform {
  required_version = "~> 1.12.0" // 1.12.0 以上 1.13.0 未満 を許容

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
  profile = "cp-terraform-prd"

  default_tags {
    tags = {
      Env = "prd"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "cp-terraform-prd"
  alias   = "us_east_1"

  default_tags {
    tags = {
      Env = "prd"
    }
  }
}
