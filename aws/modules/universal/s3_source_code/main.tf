data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "source_code" {
  bucket = var.bucket_name_suffix != "" ? "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}-${var.bucket_name_suffix}" : "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
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
