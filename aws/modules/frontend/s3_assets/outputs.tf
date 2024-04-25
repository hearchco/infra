output "bucket_id" {
  value = aws_s3_bucket.assets.id
}

output "bucket_arn" {
  value = aws_s3_bucket.assets.arn
}

output "assets" {
  value = local.assets
}

output "top_level_assets" {
  value = local.top_level_assets
}
