resource "aws_apigatewayv2_route" "route_get_routes" {
  for_each = var.routes

  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "GET ${each.key}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "route_post_routes" {
  for_each = var.routes

  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST ${each.key}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
