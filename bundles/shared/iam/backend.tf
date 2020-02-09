provider "aws" {
  region  = "eu-west-1"
  profile = "generic_user"
}

terraform {
  backend "s3" {
    key     = "iam/terraform.tfstate"
    encrypt = true
  }
}
