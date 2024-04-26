# AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = local.identifiers
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "aws_iam_role_exec_lambda" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Logging
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

resource "aws_iam_policy" "lambda_logging" {
  name        = var.policy_name
  path        = "/"
  description = "IAM policy for logging from a lambda@edge"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

# AWSLambdaBasicExecutionRole & Logging
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.aws_iam_role_exec_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
