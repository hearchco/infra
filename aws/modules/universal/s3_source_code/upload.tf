// Upload new file
resource "aws_s3_object" "source_code" {
  key         = "${var.filename}.zip"
  bucket      = aws_s3_bucket.source_code.id
  source      = var.archive_path
  source_hash = var.archive_base64sha256

  lifecycle {
    create_before_destroy = true
  }
}
