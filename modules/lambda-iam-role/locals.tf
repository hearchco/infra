locals {
  default_identifiers = toset(var.edge ? ["lambda.amazonaws.com", "edgelambda.amazonaws.com"] : ["lambda.amazonaws.com"])
  identifiers         = setunion(var.identifiers, local.default_identifiers)
}
