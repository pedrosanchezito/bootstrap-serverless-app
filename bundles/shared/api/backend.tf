provider "aws" {
  region  = var.aws_region
  profile = var.aws_user
}

terraform {
  backend "s3" {
    key     = "api/terraform.tfstate"
    encrypt = true
  }
}