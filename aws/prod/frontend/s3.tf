module "s3_assets_suffix" {
  source = "../../modules/universal/random"

  min_chars = 6
  max_chars = 10
  upper     = false
  special   = false
}

module "hearchco_s3_assets" {
  source             = "../../modules/frontend/s3_assets"
  bucket_name        = "hearchco-assets"
  bucket_name_suffix = module.s3_assets_suffix.string

  providers = {
    aws = aws.us-east-1-cdn
  }
}
