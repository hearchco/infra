output "function_name" {
  value = aws_lambda_function.ssr_lambda.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.ssr_lambda.qualified_arn // needed for Lambda@Edge
}
