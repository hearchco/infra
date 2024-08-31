resource "aws_s3_bucket" "source_code" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "source_code_ownership_controls" {
  bucket = aws_s3_bucket.source_code.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "source_code_acl" {
  bucket = aws_s3_bucket.source_code.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.source_code_ownership_controls]
}

resource "aws_s3_bucket_versioning" "source_code_versioning" {
  bucket = aws_s3_bucket.source_code.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "source_code_upload" {
  key            = var.filename
  bucket         = aws_s3_bucket.source_code.id
  content_base64 = var.content_base64
  source_hash    = var.content_base64sha256
  content_type   = "application/zip"

  lifecycle {
    create_before_destroy = true
  }
}
