terraform {
  backend "s3" {
    bucket = "cp-terraform-tomohiro-kawauchi-prd"
    key    = "main.tfstate"
    region = "ap-northeast-1"
  }
}
