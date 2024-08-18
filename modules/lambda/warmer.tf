resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  count = var.keep_warm ? 1 : 0

  name                = "${var.name}-KeepWarmRule"
  description         = "Keep Lambda warm by invoking it every 5 minutes"
  schedule_expression = "cron(0/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "warm_up_lambda_target" {
  count = var.keep_warm ? 1 : 0

  rule      = aws_cloudwatch_event_rule.every_five_minutes[0].name
  target_id = "${var.name}-WarmUpLambdaTarget"
  arn       = aws_lambda_function.function.arn
}

resource "aws_lambda_permission" "cloudwatch_invoke" {
  count = var.keep_warm ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes[0].arn
}
