resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = var.url
  client_id_list  = [var.audience]
  thumbprint_list = var.thumbprint_list
}
