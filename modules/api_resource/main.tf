resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = var.api_gw_id
  parent_id   = var.api_gw_root_resource_id
  path_part   = var.path_part
}
