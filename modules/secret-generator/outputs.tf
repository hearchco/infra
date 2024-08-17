output "string" {
  value     = random_password.secret.result
  sensitive = true
}
