module "github_oidc" {
  source = "../../modules/oidc"
}

module "github_oidc_infra_deploy_role" {
  source = "../../modules/oidc-iam-role"

  name       = var.name
  repository = var.repository
  scope      = var.scope
  statements = var.statements
}
