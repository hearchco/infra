data "aws_iam_policy_document" "dynamodb_policy_document" {
  count = var.lambda_iam_role ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.name}"]
  }
}

resource "aws_iam_policy" "dynamodb_policy" {
  count = var.lambda_iam_role ? 1 : 0

  name        = "${replace(var.name, "-", "_")}_dynamodb_access_policy"
  description = "Policy to allow Lambda to access DynamoDB"
  policy      = data.aws_iam_policy_document.dynamodb_policy_document[0].json
}
