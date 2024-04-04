resource "aws_s3_bucket" "binary" {
  bucket = local.bucket_name
}

# Ownership
resource "aws_s3_bucket_ownership_controls" "binary" {
  bucket = aws_s3_bucket.binary.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Visibility
resource "aws_s3_bucket_acl" "binary" {
  bucket = aws_s3_bucket.binary.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.binary]
}

# Versioning
resource "aws_s3_bucket_versioning" "binary" {
  bucket = aws_s3_bucket.binary.id

  versioning_configuration {
    status = "Enabled"
  }
}
