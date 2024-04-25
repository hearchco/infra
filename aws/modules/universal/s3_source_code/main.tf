resource "aws_s3_bucket" "source_code" {
  bucket = local.bucket_name
}

# Ownership
resource "aws_s3_bucket_ownership_controls" "source_code" {
  bucket = aws_s3_bucket.source_code.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Visibility
resource "aws_s3_bucket_acl" "source_code" {
  bucket = aws_s3_bucket.source_code.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.source_code]
}

# Versioning
resource "aws_s3_bucket_versioning" "source_code" {
  bucket = aws_s3_bucket.source_code.id

  versioning_configuration {
    status = "Enabled"
  }
}
