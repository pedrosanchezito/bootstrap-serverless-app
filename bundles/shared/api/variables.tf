variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "eu-west-1" # TO BE REMOVED
}

variable "aws_user" {
  description = "The AWS user that will deploy the infrastructure"
  type        = string
  default     = "generic_user" # TO BE REMOVED
}

variable "bucket_tfstate_name" {
  description = "S3 bucket where tfstates are stored"
  type        = string
  default     = "serverless-app-jj-20200128" # TO BE REMOVED
}

variable "project_name" {
  description = "Name of the project for naming and tagging purpose"
  type        = "string"
  default     = "serverless-app"
}