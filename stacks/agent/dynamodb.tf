module "cache_database" {
  source = "../../modules/dynamodb"

  name     = var.dynamodb_name
  replicas = local.dynamodb_replicas

  attributes = [
    {
      name     = "Key"
      type     = "S"
      hash_key = true
    }
    # This value is used in the application but not indexed in the database
    # Error: all attributes must be indexed. Unused attributes: ["Value"]
    # {
    #   name = "Value"
    #   type = "S"
    # }
  ]

  ttl = {
    enabled = true
  }
}
