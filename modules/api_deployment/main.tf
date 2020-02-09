resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [var.dependencies]

  rest_api_id = var.rest_api_id
  stage_name  = terraform.workspace
}