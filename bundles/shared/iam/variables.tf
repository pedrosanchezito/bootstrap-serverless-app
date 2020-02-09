# BACKEND VARIABLES
variable "aws_account" {
  description = "Account number of the AWS account used to deploy the infrastructure"
  type        = string
  default     = "424087385928" # TO BE REMOVED
}

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

