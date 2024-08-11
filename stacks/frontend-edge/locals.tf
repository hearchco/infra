locals {
  s3_static_assets_origin_id = "s3-static-assets"

  lambda_iam_role_name   = "${var.lambda_name}-iam-role"
  lambda_iam_policy_name = "${var.lambda_name}-iam-policy"
}
