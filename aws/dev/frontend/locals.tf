locals {
  api_domain_name = "api.${var.domain_name}"

  # Lambda
  environment = tomap({
    API_URI        = "https://${local.api_domain_name}"
    PUBLIC_API_URI = "https://${local.api_domain_name}"
  })
}
