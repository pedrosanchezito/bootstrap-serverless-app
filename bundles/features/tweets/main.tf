###########################
### DATA FROM OTHER BUNDLES
###########################

data "terraform_remote_state" "iam" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket  = var.bucket_tfstate_name
    key     = "iam/terraform.tfstate"
    region  = var.aws_region
    profile = var.aws_user
  }
}

data "terraform_remote_state" "api" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket  = var.bucket_tfstate_name
    key     = "api/terraform.tfstate"
    region  = var.aws_region
    profile = var.aws_user
  }
}

##################
## DATBASE BACKEND
##################

module "tweets_database" {
  source = "../../../modules/dynamodb"

  name           = "tweets"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "username"
  range_key      = "creation_date"
  project_name   = var.project_name
}

####################
### LAMBDA FUNCTIONS
####################

module "tweets_get_lambda" {
  source = "../../../modules/lambda"

  project_name              = var.project_name
  feature_name              = "tweets"
  api_method                = "get"
  lambda_description        = "GET all or specific messages"
  lambda_filename           = "../../../lambda/tweets_get.zip"
  lambda_handler            = "lambda_function.lambda_handler"
  lambda_runtime            = "python3.7"
  lambda_role_arn           = data.terraform_remote_state.iam.outputs.role_dynamodb.role_arn
  aws_region                = var.aws_region
  aws_account               = var.aws_account
  api_gw_id                 = data.terraform_remote_state.api.outputs.api_gw_id
  api_gw_method_http_method = module.tweets_get.api_method_http_method
  api_gw_resource_path      = module.tweets_resource.api_resource_path
}

module "tweets_post_lambda" {
  source = "../../../modules/lambda"

  project_name              = var.project_name
  feature_name              = "tweets"
  api_method                = "post"
  lambda_description        = "POST or UPDATE a message"
  lambda_filename           = "../../../lambda/tweets_post.zip"
  lambda_handler            = "lambda_function.lambda_handler"
  lambda_runtime            = "python3.7"
  lambda_role_arn           = data.terraform_remote_state.iam.outputs.role_dynamodb.role_arn
  aws_region                = var.aws_region
  aws_account               = var.aws_account
  api_gw_id                 = data.terraform_remote_state.api.outputs.api_gw_id
  api_gw_method_http_method = module.tweets_post.api_method_http_method
  api_gw_resource_path      = module.tweets_resource.api_resource_path
}

module "tweets_delete_lambda" {
  source = "../../../modules/lambda"

  project_name              = var.project_name
  feature_name              = "tweets"
  api_method                = "delete"
  lambda_description        = "DELETE a specific messages"
  lambda_filename           = "../../../lambda/tweets_delete.zip"
  lambda_handler            = "lambda_function.lambda_handler"
  lambda_runtime            = "python3.7"
  lambda_role_arn           = data.terraform_remote_state.iam.outputs.role_dynamodb.role_arn
  aws_region                = var.aws_region
  aws_account               = var.aws_account
  api_gw_id                 = data.terraform_remote_state.api.outputs.api_gw_id
  api_gw_method_http_method = module.tweets_delete.api_method_http_method
  api_gw_resource_path      = module.tweets_resource.api_resource_path
}

#########################
### TWEET API AND METHODS
#########################

module "tweets_resource" {
  source = "../../../modules/api_resource"

  api_gw_id               = data.terraform_remote_state.api.outputs.api_gw_id
  api_gw_root_resource_id = data.terraform_remote_state.api.outputs.api_gw_root_resource_id
  path_part               = "tweets"
}

module "tweets_get" {
  source = "../../../modules/api_method"

  api_gw_id               = data.terraform_remote_state.api.outputs.api_gw_id
  api_resource_id         = module.tweets_resource.api_resource_id
  http_method             = "GET"
  integration_http_method = "POST"
  authorization           = "NONE"
  type                    = "AWS_PROXY"
  uri                     = module.tweets_get_lambda.lambda_invoke_arn
  integration_request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
  integration_response_needed     = false
  integration_status_code         = 200
  integration_response_parameters = null
  response_status_code            = 200
  response_response_parameters    = null
  response_response_model = {
    "application/json" = "Empty"
  }
}

module "tweets_post" {
  source = "../../../modules/api_method"

  api_gw_id               = data.terraform_remote_state.api.outputs.api_gw_id
  api_resource_id         = module.tweets_resource.api_resource_id
  http_method             = "POST"
  integration_http_method = "POST"
  authorization           = "NONE"
  type                    = "AWS_PROXY"
  uri                     = module.tweets_post_lambda.lambda_invoke_arn
  integration_request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
  integration_response_needed     = false
  integration_status_code         = 200
  integration_response_parameters = null
  response_status_code            = 200
  response_response_parameters    = null
  response_response_model = {
    "application/json" = "Empty"
  }
}

module "tweets_delete" {
  source = "../../../modules/api_method"

  api_gw_id               = data.terraform_remote_state.api.outputs.api_gw_id
  api_resource_id         = module.tweets_resource.api_resource_id
  http_method             = "DELETE"
  integration_http_method = "POST"
  authorization           = "NONE"
  type                    = "AWS_PROXY"
  uri                     = module.tweets_delete_lambda.lambda_invoke_arn
  integration_request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
  integration_response_needed     = false
  integration_status_code         = 200
  integration_response_parameters = null
  response_status_code            = 200
  response_response_parameters    = null
  response_response_model = {
    "application/json" = "Empty"
  }
}

module "tweets_enable_CORS" {
  source = "../../../modules/api_method"

  api_gw_id               = data.terraform_remote_state.api.outputs.api_gw_id
  api_resource_id         = module.tweets_resource.api_resource_id
  http_method             = "OPTIONS"
  integration_http_method = null
  authorization           = "NONE"
  type                    = "MOCK"
  uri                     = null
  integration_request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
  integration_response_needed = true
  integration_status_code     = 200
  integration_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  response_status_code = 200
  response_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  response_response_model = {
    "application/json" = "Empty"
  }
}

##################
### API DEPLOYMENT
##################

module "tweets_api_deployment" {
  source = "../../../modules/api_deployment"

  dependencies = [
    module.tweets_get.api_method_api_gateway_integration,
    module.tweets_post.api_method_api_gateway_integration,
    module.tweets_delete.api_method_api_gateway_integration,
    module.tweets_enable_CORS.api_method_api_gateway_integration_CORS
  ]
  rest_api_id = data.terraform_remote_state.api.outputs.api_gw_id
}