output "bucket_id" {
  value = aws_s3_bucket.source_code.id
}

output "bucket_arn" {
  value = aws_s3_bucket.source_code.arn
}

output "s3_key" {
  value = aws_s3_object.source_code.key
}

output "source_code_hash" {
  value = aws_s3_object.source_code.source_hash
}
