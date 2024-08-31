module "src_downloader" {
  source = "../../modules/github-asset-downloader"

  release_repository       = "frontend"
  release_repository_owner = "hearchco"
  release_tag              = var.release_tag
  release_asset_name       = "hearchco_index_mjs_aws.zip"
}

module "lambda_iam" {
  source = "../../modules/lambda-iam-role"

  role_name   = local.lambda_iam_role_name
  policy_name = local.lambda_iam_policy_name
}
