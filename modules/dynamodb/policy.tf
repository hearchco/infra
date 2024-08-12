resource "aws_iam_policy" "dynamodb_policy" {
  count = var.lambda_iam_role ? 1 : 0

  name        = "${replace(var.name, "-", "_")}_dynamodb_access_policy"
  description = "Policy to allow Lambda to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ]
      Resource = "arn:aws:dynamodb:*:*:table/${aws_dynamodb_table.table.name}"
    }]
  })
}
