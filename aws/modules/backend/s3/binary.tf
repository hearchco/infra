data "archive_file" "hearchco_binary" {
  type        = "zip"
  source_file = local.source_file
  output_path = local.output_path
}

resource "aws_s3_object" "hearchco_binary" {
  key                    = "${local.binary_name}.zip"
  bucket                 = aws_s3_bucket.hearchco_binary.id
  source                 = data.archive_file.hearchco_binary.output_path
  server_side_encryption = "aws:kms"
  etag                   = filemd5(data.archive_file.hearchco_binary.output_path)
}
