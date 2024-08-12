output "dynamodb_table_name" {
  value = aws_dynamodb_table.table.name
}

output "lambda_access_policy_arn" {
  value = var.lambda_iam_role ? aws_iam_policy.dynamodb_policy[0].arn : null
}
