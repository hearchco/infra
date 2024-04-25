resource "aws_route53_record" "record" {
  name    = var.domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    name                   = aws_cloudfront_distribution.api_gateway_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.api_gateway_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "record_v6" {
  name    = var.domain_name
  type    = "AAAA"
  zone_id = var.hosted_zone_id

  alias {
    name                   = aws_cloudfront_distribution.api_gateway_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.api_gateway_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
