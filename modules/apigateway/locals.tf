data "aws_region" "current" {}

locals {
  regional_domain_name = "${data.aws_region.current.name}.${var.domain_name}"
}
