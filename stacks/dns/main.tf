module "dns" {
  source      = "../../modules/route53"
  domain_name = var.domain_name
  records     = var.records
}
