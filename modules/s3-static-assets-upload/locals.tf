data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name = var.bucket_name_suffix != "" ? "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}-${var.bucket_name_suffix}" : "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"

  // Get a list of all files in the assets folder
  assets_fileset = fileset(var.assets_path, "**/*")

  // Map of asset file names to their content types
  assets_with_content_type_map = {
    for asset in local.assets_fileset :
    asset => lookup(var.content_types, ".${split(".", asset)[length(split(".", asset)) - 1]}", "application/octet-stream")
  }

  // Top level files and folders (e.g. index.html, images/*)
  top_level_assets = toset([
    for asset in local.assets_fileset :
    length(split("/", asset)) == 1 ?
    "/${split("/", asset)[0]}" :
    "/${split("/", asset)[0]}/*"
  ])
}
