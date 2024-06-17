locals {
  # Lambda
  environment = tomap({
    HEARCHCO_SERVER_FRONTENDURLS = "http://localhost:5173,https://hearch.co,https://frontend-*-hearchco.vercel.app"
    HEARCHCO_SERVER_CACHE_TYPE   = "none" # currently caching has some bugs so it's disabled
  })
  # Not inside environment because it's a secret
  proxy_salt = module.salt.string

  # API Gateway
  api_domain_name         = "api.${var.domain_name}"
  api_gateway_domain_name = "gateway.${local.api_domain_name}"
  routes = toset([
    "/search",
    "/proxy",
    "/healthz",
    "/versionz"
  ])
}
