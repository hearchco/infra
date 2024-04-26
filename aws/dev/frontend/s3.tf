module "hearchco_s3_assets" {
  source      = "../../modules/frontend/s3_assets"
  bucket_name = "hearchco-assets"

  providers = {
    aws = aws.us-east-1-cdn
  }
}
