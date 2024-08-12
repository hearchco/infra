data "aws_region" "current" {}

locals {
  api_gateway_origin_id = "api-gateway-lambda"

  lambda_iam_role_name   = "${var.lambda_name}-iam-role"
  lambda_iam_policy_name = "${var.lambda_name}-iam-policy"

  lambda_environment = merge(
    {
      "HEARCHCO_SERVER_ENVIRONMENT"           = "lambda"
      "HEARCHCO_SERVER_CACHE_TYPE"            = "dynamodb"
      "HEARCHCO_SERVER_CACHE_DYNAMODB_REGION" = "global"
      "HEARCHCO_SERVER_CACHE_DYNAMODB_TABLE"  = module.cache_database.dynamodb_table_name
      "HEARCHCO_SERVER_IMAGEPROXY_SECRETKEY"  = module.image_proxy_secret_key.string
    },
    var.lambda_environment
  )

  dynamodb_replicas = setsubtract(
    var.aws_regions,
    [data.aws_region.current.name]
  )
}
