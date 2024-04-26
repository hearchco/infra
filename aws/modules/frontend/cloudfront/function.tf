resource "aws_cloudfront_function" "sveltekit-rewriter" {
  name    = "sveltekit-rewriter"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file(var.function_path)
}
