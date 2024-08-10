include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${path_relative_from_include()}/../..//stacks/dns"
}

locals {
  environment = include.root.locals.environment
  aws_profile = include.root.locals.aws_profile
  domain_name = include.root.locals.domain_name

  records = []
}

inputs = {
  domain_name = local.domain_name
  records     = local.records
}
