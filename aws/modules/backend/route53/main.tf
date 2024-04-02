resource "aws_route53_zone" "api" {
  name = var.domain_name
}
