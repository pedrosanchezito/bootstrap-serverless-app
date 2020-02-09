resource "aws_lambda_function" "function" {
  function_name = "${var.project_name}-${terraform.workspace}-${var.feature_name}-${var.api_method}"
  description   = var.lambda_description
  filename      = var.lambda_filename
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = var.lambda_role_arn

  environment {
    variables = {
      env = terraform.workspace
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account}:${var.api_gw_id}/*/${var.api_gw_method_http_method}${var.api_gw_resource_path}"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 14
}
