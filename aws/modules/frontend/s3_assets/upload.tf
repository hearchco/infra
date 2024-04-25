// Upload new file
resource "aws_s3_object" "assets" {
  for_each = local.assets

  key         = each.key
  bucket      = aws_s3_bucket.assets.id
  source      = each.key
  source_hash = filebase64sha256(each.key)
}
