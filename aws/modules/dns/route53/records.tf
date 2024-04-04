resource "aws_route53_record" "additional" {
  for_each = local.additional_records_map

  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  zone_id = aws_route53_zone.zone.zone_id
  records = each.value.records
}
