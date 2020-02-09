# API BUNDLE
# define here the parameters to create the API Gateway

module "api_gateway" {
  source = "../../../modules/api_gateway"

  project_name = var.project_name
}