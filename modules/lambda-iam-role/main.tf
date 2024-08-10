data "aws_iam_policy_document" "lambda_execute" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = local.identifiers
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "lambda_execute" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_execute.json
}

resource "aws_iam_policy" "lambda_logging" {
  name        = var.policy_name
  path        = "/"
  description = "IAM policy for logging from lambda@edge"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_iam" {
  role       = aws_iam_role.lambda_execute.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
