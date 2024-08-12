output "function_name" {
  value = aws_lambda_function.function.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.function.invoke_arn
}

output "qualified_arn" {
  value = aws_lambda_function.function.qualified_arn
}
