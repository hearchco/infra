module "github_oidc" {
  source = "../../modules/oidc"
}

module "github_oidc_infra_deploy_role" {
  source = "../../modules/oidc-iam-role"

  name       = "github-auth-tf-state-lock"
  repository = "hearchco/infra"
  scope      = var.scope
  statements = var.statements
}
