data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  binary_name = "bootstrap"
  binary_key  = "${local.binary_name}.zip"
  source_file = "${var.path}/${local.binary_name}"
  output_path = "${local.source_file}.zip"
}
