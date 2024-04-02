resource "aws_apigatewayv2_route" "hearchco_route_get_routes" {
  for_each = var.routes

  api_id    = aws_apigatewayv2_api.hearchco_http_api.id
  route_key = "GET ${each.key}"
  target    = "integrations/${aws_apigatewayv2_integration.hearchco_lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "hearchco_route_post_routes" {
  for_each = var.routes

  api_id    = aws_apigatewayv2_api.hearchco_http_api.id
  route_key = "POST ${each.key}"
  target    = "integrations/${aws_apigatewayv2_integration.hearchco_lambda_integration.id}"
}
