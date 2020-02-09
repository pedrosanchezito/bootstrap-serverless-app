provider "aws" {
  region  = var.aws_region
}

terraform {
  backend "s3" {
    key     = "tweets/terraform.tfstate"
    encrypt = true
  }
}