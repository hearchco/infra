resource "aws_cloudfront_function" "cf_functions" {
  for_each = var.cf_functions

  name    = each.value.name
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file(each.value.path)
}
