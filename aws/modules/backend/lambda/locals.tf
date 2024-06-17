locals {
  default_env = tomap({
    HEARCHCO_SERVER_ENVIRONMENT = "lambda"
    HEARCHCO_SERVER_IMAGEPROXY_SALT  = var.proxy_salt
  })

  environment = var.use_default_env ? tomap(merge(local.default_env, var.environment)) : var.environment
}
