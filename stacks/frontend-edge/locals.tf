locals {
  s3_static_assets_origin_id = "s3-static-assets"

  lambda_iam_role_name   = "${var.lambda_name}-iam-role"
  lambda_iam_policy_name = "${var.lambda_name}-iam-policy"

  lambda_environment = merge(
    {
      "PUBLIC_URI"     = "https://${var.cloudfront_domain_name}"
      "API_URI"        = "https://${var.lambda_agent_api_gateway_domain_name}"
      "PUBLIC_API_URI" = "https://${var.lambda_agent_cloudfront_domain_name}"
    },
    var.lambda_environment
  )
}
