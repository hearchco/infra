output "bucket_id" {
  value = aws_s3_bucket.binary.id
}

output "bucket_arn" {
  value = aws_s3_bucket.binary.arn
}

output "s3_key" {
  value = aws_s3_object.binary.key
}

output "source_code_hash" {
  value = aws_s3_object.binary.source_hash
}
