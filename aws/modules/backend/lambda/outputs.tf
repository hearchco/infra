output "function_name" {
  value = aws_lambda_function.api_lambda.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.api_lambda.invoke_arn
}
