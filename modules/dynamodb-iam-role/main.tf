data "aws_iam_policy_document" "dynamodb_policy_document" {
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
  name        = "${replace(var.name, "-", "_")}_dynamodb_access_policy"
  description = "Policy to allow Lambda to access DynamoDB"
  policy      = data.aws_iam_policy_document.dynamodb_policy_document.json
}
