resource "aws_api_gateway_rest_api" "api_gw" {
  name        = "${var.project_name}-${terraform.workspace}-api"
  description = "API for the serverless app"
}