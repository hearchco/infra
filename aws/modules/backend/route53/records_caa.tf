resource "aws_route53_record" "caa" {
  name    = var.domain_name
  type    = "CAA"
  ttl     = 86400
  zone_id = aws_route53_zone.api.zone_id
  records = var.records_caa
}
