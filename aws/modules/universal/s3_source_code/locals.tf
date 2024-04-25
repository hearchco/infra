data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  source_key  = "${var.source_name}.zip"
  source_file = "${var.path}/${var.source_name}"
  output_path = "${local.source_file}.zip"
}
