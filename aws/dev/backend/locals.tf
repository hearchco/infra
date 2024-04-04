locals {
  # Lambda
  environment = tomap({
    HEARCHCO_SERVER_FRONTENDURLS = "http://localhost:5173,https://*hearch.co,https://*hearchco-frontend.pages.dev"
    HEARCHCO_SERVER_CACHE_TYPE   = "none" # currently caching has some bugs so it's disabled
  })
  # Not inside environment because it's a secret
  proxy_salt = module.salt.string

  # API Gateway
  api_gateway_domain_name = "gateway.${var.api_domain_name}"
  routes = toset([
    "/search",
    "/proxy",
  ])
}
