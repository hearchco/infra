// Upload new file
data "archive_file" "source_code" {
  type        = "zip"
  source_file = "${var.path}/${var.filename}"
  output_path = "${var.path}/${var.filename}.zip"
}

resource "aws_s3_object" "source_code" {
  key         = "${var.filename}.zip"
  bucket      = aws_s3_bucket.source_code.id
  source      = data.archive_file.source_code.output_path
  source_hash = data.archive_file.source_code.output_base64sha256

  lifecycle {
    create_before_destroy = true
  }
}
