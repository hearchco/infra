output "bucket_regional_domain_name" {
  value = aws_s3_bucket.assets.bucket_regional_domain_name
}

output "assets" {
  value = local.assets
}

output "top_level_assets" {
  value = local.top_level_assets
}

output "oai" {
  value = aws_cloudfront_origin_access_identity.oai.id
}
