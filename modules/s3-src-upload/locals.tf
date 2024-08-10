data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name = var.bucket_name_suffix != "" ? "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}-${var.bucket_name_suffix}" : "${var.bucket_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
}
