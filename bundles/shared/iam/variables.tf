variable "aws_account" {
  description = "Account number of the AWS account used to deploy the infrastructure"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
}

variable "bucket_tfstate_name" {
  description = "S3 bucket where tfstates are stored"
  type        = string
}

variable "project_name" {
  description = "Name of the project for naming and tagging purpose"
  type        = string
  default     = "serverless-app"
}