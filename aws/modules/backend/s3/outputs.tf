output "bucket_id" {
  value = aws_s3_bucket.hearchco_binary.id
}

output "bucket_arn" {
  value = aws_s3_bucket.hearchco_binary.arn
}

output "s3_key" {
  value = aws_s3_object.hearchco_binary.key
}

output "source_code_hash" {
  value = data.archive_file.hearchco_binary.output_base64sha256
}
