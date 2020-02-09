resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = var.api_gw_id
  resource_id   = var.api_resource_id
  http_method   = var.http_method
  authorization = var.authorization
}

resource "aws_api_gateway_integration" "api_integration" {
  count                   = var.integration_http_method != "OPTIONS" ? 1 : 0
  rest_api_id             = var.api_gw_id
  resource_id             = var.api_resource_id
  http_method             = var.http_method
  integration_http_method = var.integration_http_method
  type                    = var.type
  uri                     = var.uri

  depends_on = [
    aws_api_gateway_method.api_method,
  ]
}

resource "aws_api_gateway_integration" "api_integration_CORS" {
  count             = var.integration_http_method == "OPTIONS" ? 1 : 0
  rest_api_id       = var.api_gw_id
  resource_id       = var.api_resource_id
  http_method       = var.http_method
  type              = var.type
  request_templates = var.integration_request_templates

  depends_on = [
    aws_api_gateway_method.api_method,
  ]
}

resource "aws_api_gateway_integration_response" "api_integration_response" {
  count               = var.integration_response_needed ? 1 : 0
  rest_api_id         = var.api_gw_id
  resource_id         = var.api_resource_id
  http_method         = var.http_method
  status_code         = var.integration_status_code
  response_parameters = var.integration_response_parameters

  depends_on = [
    aws_api_gateway_integration.api_integration,
    aws_api_gateway_integration.api_integration_CORS,
    aws_api_gateway_method_response.api_method_response,
  ]
}

resource "aws_api_gateway_method_response" "api_method_response" {
  rest_api_id         = var.api_gw_id
  resource_id         = var.api_resource_id
  http_method         = var.http_method
  status_code         = var.response_status_code
  response_parameters = var.response_response_parameters
  response_models     = var.response_response_model

//  depends_on = [
//    aws_api_gateway_method.api_method,
//  ]
}