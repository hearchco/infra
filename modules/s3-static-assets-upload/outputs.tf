output "bucket_domain_name" {
  value = aws_s3_bucket.assets.bucket_domain_name
}

output "assets" {
  value = local.assets_fileset
}

output "top_level_assets" {
  value = local.top_level_assets
}

output "oai_id" {
  value = aws_cloudfront_origin_access_identity.oai.id
}
