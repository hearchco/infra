resource "aws_lambda_function" "ssr_lambda" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role

  s3_bucket        = var.s3_bucket
  s3_key           = var.s3_key
  source_code_hash = var.source_code_hash

  architectures = var.architectures
  memory_size   = var.memory_size
  timeout       = var.timeout

  // needed for Lambda@Edge
  publish = true
}
