resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "records" {
  for_each = local.records_map

  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  zone_id = aws_route53_zone.zone.zone_id
  records = each.value.records
}


resource "aws_route53_record" "records_caa" {
  name    = var.domain_name
  type    = "CAA"
  ttl     = 86400
  zone_id = aws_route53_zone.zone.zone_id
  records = var.records_caa
}
