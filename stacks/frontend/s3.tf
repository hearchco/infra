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

  providers = {
    aws = aws.global
  }
}

# module "s3_src_downloader" {
#   source = "../../modules/github-asset-downloader"

#   release_repository       = var.release_repository
#   release_repository_owner = var.release_repository_owner
#   release_tag              = var.release_tag
#   release_asset_name       = "hearchco_s3_assets_aws.zip"
# }

# module "s3_src_unarchiver" {
#   source = "../../modules/unarchive-zip"

#   filename = "hearchco_s3_assets_aws.zip"
#   content = {
#     content_base64 = module.s3_src_downloader.content_base64
#   }

#   depends_on = [module.s3_src_downloader]
# }

# module "s3_static_assets_bucket_name_suffix" {
#   source = "../../modules/secret-generator"

#   min_chars = 6
#   max_chars = 10
#   upper     = false
#   special   = false
# }

# module "s3_static_assets_bucket" {
#   source = "../../modules/s3-static-assets-upload"

#   bucket_name        = var.s3_bucket_name
#   bucket_name_suffix = module.s3_static_assets_bucket_name_suffix.string
#   assets_path        = module.s3_src_unarchiver.output_path

#   providers = {
#     aws = aws.global
#   }

#   depends_on = [module.s3_src_unarchiver]
# }
