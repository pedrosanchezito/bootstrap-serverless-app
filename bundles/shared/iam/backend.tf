provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    key     = "iam/terraform.tfstate"
    encrypt = true
  }
}
