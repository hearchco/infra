resource "aws_s3_bucket" "assets" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "assets_ownership_controls" {
  bucket = aws_s3_bucket.assets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "assets_acl" {
  bucket = aws_s3_bucket.assets.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.assets_ownership_controls]
}

resource "aws_s3_bucket_versioning" "assets_versioning" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "assets_upload" {
  for_each = local.assets_with_content_type_map

  key          = each.key
  bucket       = aws_s3_bucket.assets.id
  source       = "${var.assets_path}/${each.key}"
  source_hash  = filebase64sha256("${var.assets_path}/${each.key}")
  content_type = each.value

  lifecycle {
    create_before_destroy = true
  }
}
