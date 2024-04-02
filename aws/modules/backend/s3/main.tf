resource "aws_s3_bucket" "hearchco_binary" {
  bucket = var.bucket_prefix != "" ? "${var.bucket_prefix}-${var.bucket_name}" : var.bucket_name
}

# Ownership
resource "aws_s3_bucket_ownership_controls" "hearchco_binary" {
  bucket = aws_s3_bucket.hearchco_binary.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Visibility
resource "aws_s3_bucket_acl" "hearchco_binary" {
  bucket = aws_s3_bucket.hearchco_binary.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.hearchco_binary]
}

# Versioning
resource "aws_s3_bucket_versioning" "hearchco_binary" {
  bucket = aws_s3_bucket.hearchco_binary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# SSE
resource "aws_kms_key" "hearchco_binary" {
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "hearchco_binary" {
  bucket = aws_s3_bucket.hearchco_binary.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.hearchco_binary.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Replication
resource "aws_s3_bucket_replication_configuration" "hearchco_binary" {
  count = var.replica ? 0 : 1

  bucket = aws_s3_bucket.hearchco_binary.id
  role   = aws_iam_role.replication[0].arn

  dynamic "rule" {
    for_each = var.buckets_to_replicate
    content {
      id       = "${rule.key}-replicate-objects"
      status   = "Enabled"
      priority = local.buckets_to_replicate_index[rule.key]

      filter {
        prefix = "${local.binary_name}.zip"
      }

      delete_marker_replication {
        status = "Enabled"
      }

      destination {
        bucket = rule.value
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.hearchco_binary]
}
