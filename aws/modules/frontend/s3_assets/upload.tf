// Upload new file
resource "aws_s3_object" "assets" {
  for_each = local.assets_with_content_type

  key          = each.key
  bucket       = aws_s3_bucket.assets.id
  source       = "${var.path}/${each.key}"
  source_hash  = filebase64sha256("${var.path}/${each.key}")
  content_type = each.value
}
