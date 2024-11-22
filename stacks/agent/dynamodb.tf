module "dynamodb_policy" {
  source = "../../modules/dynamodb-iam-role"

  name = var.dynamodb_name
}
