module "s3_static_assets_bucket_name_suffix" {
  source = "../../modules/secret-generator"

  min_chars = 6
  max_chars = 10
  upper     = false
  special   = false
}

module "s3_static_assets_bucket" {
  source = "../../modules/s3-static-assets-upload"

  bucket_name        = var.s3_bucket_name
  bucket_name_suffix = module.s3_static_assets_bucket_name_suffix.string
  assets_path        = var.s3_static_assets_path
}
