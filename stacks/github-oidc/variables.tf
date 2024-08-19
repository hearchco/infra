variable "name" {
  description = "The name of the IAM role"
  type        = string
  default     = "github-oidc-auth-role"
}

variable "repository" {
  description = "The GitHub repository to grant access to"
  type        = string
  default     = "hearchco/infra"
}

variable "scope" {
  description = "The scope of the access, e.g. 'ref:refs/heads/main', 'ref:refs/heads/*' or '*'"
  type        = string
  default     = "ref:refs/heads/main"
}

variable "statements" {
  description = "The statements to add to the inline policy"
  type = set(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = set(string)
    resources = set(string)
  }))
  default = [
    # Terraform state statements
    {
      actions = [
        "s3:ListBucket"
      ]
      resources = ["arn:aws:s3:::*-tf-state"]
    },
    {
      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ]
      resources = ["arn:aws:s3:::*-tf-state/*"]
    },
    {
      actions = [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ]
      resources = ["arn:aws:dynamodb:*:*:table/*-tf-state-lock"]
    },
    # Deployment statements
    {
      actions = [
        "s3:Get*",
        "s3:List*",
        "route53:Get*",
        "route53:List*",
        "apigateway:GET",
        "acm:List*",
        "acm:Describe*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "lambda:Get*",
        "lambda:List*",
        "iam:Get*",
        "iam:List*"
      ]
      resources = ["*"]
    },
    {
      actions = [
        "s3:PutObject",
        "lambda:UpdateFunctionCode"
      ]
      resources = [
        "arn:aws:s3:::*/*",
        "arn:aws:lambda:*:*:function:*"
      ]
    }
  ]
}
