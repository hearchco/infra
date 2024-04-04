// Upload new file
data "archive_file" "binary" {
  type        = "zip"
  source_file = local.source_file
  output_path = local.output_path
}

resource "aws_s3_object" "binary" {
  key         = local.binary_key
  bucket      = aws_s3_bucket.binary.id
  source      = data.archive_file.binary.output_path
  source_hash = data.archive_file.binary.output_base64sha256
}
