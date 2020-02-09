output "apigw_id" {
  value = aws_api_gateway_rest_api.api_gw.id
}

output "apigw_root_resource_id" {
  value = aws_api_gateway_rest_api.api_gw.root_resource_id
}

output "apigw_name" {
  value = aws_api_gateway_rest_api.api_gw.name
}