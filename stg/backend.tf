terraform {
  backend "s3" {
    bucket = "cp-terraform-tomohiro-kawauchi-stg"
    key    = "main.tfstate"
    region = "ap-northeast-1"
  }
}
