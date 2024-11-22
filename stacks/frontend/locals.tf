locals {
  s3_static_assets_origin_id = "s3-static-assets"
  api_gateway_origin_id      = "api-gateway-lambda"

  lambda_src_key         = "index.mjs.zip"
  lambda_iam_role_name   = "${var.lambda_name}-iam-role"
  lambda_iam_policy_name = "${var.lambda_name}-iam-policy"

  lambda_environment = merge(
    {},
    var.lambda_environment
  )
}
