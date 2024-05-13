resource "aws_s3_bucket" "assets" {
  bucket = var.bucket_name_suffix != "" ? "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}-${var.bucket_name_suffix}" : "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
}

# Ownership
resource "aws_s3_bucket_ownership_controls" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Visibility
resource "aws_s3_bucket_acl" "assets" {
  bucket = aws_s3_bucket.assets.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.assets]
}

# Versioning
resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}
