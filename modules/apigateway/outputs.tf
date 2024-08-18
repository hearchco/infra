output "target_domain_name" {
  value      = var.domain_name
  depends_on = [aws_apigatewayv2_api.gateway]
}

output "target_regional_domain_name" {
  value      = local.regional_domain_name
  depends_on = [aws_apigatewayv2_api.gateway]
}
