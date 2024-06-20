locals {
  # Lambda
  environment = tomap({
    HEARCHCO_VERBOSITY           = "1"
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

  # regions = [
  #   "af_south_1",
  #   "ap_east_1",
  #   "ap_northeast_1",
  #   "ap_northeast_2",
  #   "ap_south_1",
  #   "ap_southeast_1",
  #   "ap_southeast_2",
  #   "ca_central_1",
  #   "eu_central_1",
  #   "eu_central_2",
  #   "eu_north_1",
  #   "eu_south_1",
  #   "eu_south_2",
  #   "eu_west_1",
  #   "eu_west_2",
  #   "eu_west_3",
  #   "me_south_1",
  #   "sa_east_1",
  #   "us_east_1",
  #   "us_east_2",
  #   "us_west_1",
  #   "us_west_2"
  # ]
}
