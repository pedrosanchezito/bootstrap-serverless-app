provider "aws" {
  region  = var.aws_region
  profile = var.aws_user
}

terraform {
  backend "s3" {
    key     = "tweets/terraform.tfstate"
    encrypt = true
  }
}