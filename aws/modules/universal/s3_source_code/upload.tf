// Upload new file
data "archive_file" "source_code" {
  type        = "zip"
  source_file = local.source_file
  output_path = local.output_path
}

resource "aws_s3_object" "source_code" {
  key         = local.source_key
  bucket      = aws_s3_bucket.source_code.id
  source      = data.archive_file.source_code.output_path
  source_hash = data.archive_file.source_code.output_base64sha256
}
