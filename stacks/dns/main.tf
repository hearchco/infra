module "dns" {
  source      = "../../modules/route53"
  domain_name = var.domain_name
  records     = var.records
  dnssec      = var.dnssec

  providers = {
    aws = aws.global
  }
}
