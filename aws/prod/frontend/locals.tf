locals {
  api_domain_name = "api.${var.domain_name}"

  # Lambda
  environment = tomap({
    DEBUG          = "true"
    PUBLIC_URI     = "https://${var.domain_name}"
    API_URI        = "https://${local.api_domain_name}"
    PUBLIC_API_URI = "https://${local.api_domain_name}"
  })
}
