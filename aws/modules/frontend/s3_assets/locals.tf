data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"

  assets           = fileset(var.path, "**/*")
  top_level_assets = toset([for asset in local.assets : split("/", asset)[0]])
}
