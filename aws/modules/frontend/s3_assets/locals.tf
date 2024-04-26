data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"

  assets = fileset(var.path, "**/*")

  assets_with_content_type = {
    for asset in local.assets :
    asset => lookup(var.content_types, ".${split(".", asset)[length(split(".", asset)) - 1]}", "application/octet-stream")
  }

  // Top level files and folders (e.g. index.html, images/*)
  top_level_assets = toset([
    for asset in local.assets :
    length(split("/", asset)) == 1 ?
    "/${split("/", asset)[0]}" :
    "/${split("/", asset)[0]}/*"
  ])
}
