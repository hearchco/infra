data "aws_region" "current" {}

locals {
  bucket_name = "${var.bucket_name}-${data.aws_region.current.name}"
  binary_name = "bootstrap"
  binary_key  = "${local.binary_name}.zip"
  source_file = "${var.path}/${local.binary_name}"
  output_path = "${local.source_file}.zip"
}
