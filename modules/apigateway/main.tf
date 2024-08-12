resource "aws_apigatewayv2_api" "gateway" {
  name          = var.name
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.gateway.id
  integration_type       = var.integration_type
  integration_uri        = var.invoke_arn
  integration_method     = var.integration_method
  payload_format_version = var.payload_format_version
  connection_type        = var.connection_type
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy
}

resource "aws_apigatewayv2_domain_name" "domain_name" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.acm_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  api_id      = aws_apigatewayv2_api.gateway.id
  domain_name = aws_apigatewayv2_domain_name.domain_name.id
  stage       = aws_apigatewayv2_stage.stage.id
}
