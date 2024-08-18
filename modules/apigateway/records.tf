resource "aws_route53_record" "api_gateway_latency" {
  name    = var.domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  set_identifier = data.aws_region.current.name
  latency_routing_policy {
    region = data.aws_region.current.name
  }

  alias {
    name                   = aws_apigatewayv2_domain_name.domain_name_latency.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain_name_latency.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_gateway_latency_v6" {
  name    = var.domain_name
  type    = "AAAA"
  zone_id = var.hosted_zone_id

  set_identifier = data.aws_region.current.name
  latency_routing_policy {
    region = data.aws_region.current.name
  }

  alias {
    name                   = aws_apigatewayv2_domain_name.domain_name_latency.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain_name_latency.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_gateway_regional" {
  name    = local.regional_domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.domain_name_regional.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain_name_regional.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_gateway_regional_v6" {
  name    = local.regional_domain_name
  type    = "AAAA"
  zone_id = var.hosted_zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.domain_name_regional.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain_name_regional.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}
