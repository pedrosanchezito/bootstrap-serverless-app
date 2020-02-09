output "api_method_http_method" {
  value = aws_api_gateway_method.api_method.http_method
}

output "api_method_api_gateway_integration" {
  value = aws_api_gateway_integration.api_integration
}

output "api_method_api_gateway_integration_CORS" {
  value = aws_api_gateway_integration.api_integration_CORS
}