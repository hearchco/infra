resource "aws_route53_key_signing_key" "dnssec_signing_key" {
  count = var.dnssec ? 1 : 0

  hosted_zone_id             = aws_route53_zone.zone.id
  key_management_service_arn = aws_kms_key.dnssec_key[0].arn
  name                       = "${replace(var.domain_name, ".", "-")}-dnssec-key"
}

resource "aws_route53_hosted_zone_dnssec" "dnssec" {
  count = var.dnssec ? 1 : 0

  hosted_zone_id = aws_route53_key_signing_key.dnssec_signing_key[0].hosted_zone_id
}
