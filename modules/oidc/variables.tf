variable "url" {
  description = "The URL of the OIDC provider"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "audience" {
  description = "The audience of the OIDC provider"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "thumbprint_list" {
  description = "A list of thumbprints of the OIDC provider's certificate"
  type        = set(string)
  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}
