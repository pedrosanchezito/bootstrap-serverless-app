provider "aws" {
  region  = var.aws_region
}

terraform {
  backend "s3" {
    key     = "api/terraform.tfstate"
    encrypt = true
  }
}