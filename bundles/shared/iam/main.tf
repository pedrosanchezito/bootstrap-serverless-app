# IAM BUNDLE
# define here all required policies and roles to run the app

module "policy_lambda_logs" {
  source = "../../../modules/iam_policy"

  aws_account        = var.aws_account
  aws_region         = var.aws_region
  target_resource    = null
  policy_name        = "${var.project_name}-${terraform.workspace}-lambda_logs_policy"
  policy_description = "Grant the permissions to write logs to Cloudwatch"
  policy_content     = file("../../policies/lambda_logs.json")
}

module "policy_lambda_dynamodb" {
  source = "../../../modules/iam_policy"

  aws_account        = var.aws_account
  aws_region         = var.aws_region
  target_resource    = "table/${terraform.workspace}-tweets"
  policy_name        = "${var.project_name}-${terraform.workspace}-lambda_dynamodb_policy"
  policy_description = "Grant the permissions to use DynamoDB"
  policy_content     = file("../../policies/lambda_dynamodb.json")
}

module "roles_lambda_dynamodb" {
  source = "../../../modules/iam_role"

  role_name               = "${var.project_name}-${terraform.workspace}-lambda_dynamodb_role"
  role_description        = "Grant the lambda function the permissions to use DynamoDB"
  role_assume_role_policy = file("../../policies/assume_role_lambda.json")
  role_policy_arn         = module.policy_lambda_dynamodb.policy_arn
  role_policy_logs_arn    = module.policy_lambda_logs.policy_arn
}