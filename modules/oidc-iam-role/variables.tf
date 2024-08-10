variable "name" {
  description = "The name of the role"
  type        = string
}

variable "path" {
  description = "The path of the role"
  type        = string
  default     = "/"
}

variable "audience" {
  description = "The audience of the OIDC provider"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "repository" {
  description = "The GitHub repository to allow access to in the format '<org_name>/<repo_name>'"
  type        = string
}

variable "scope" {
  description = "The scope of the access, e.g. 'ref:refs/heads/main', 'ref:refs/heads/*' or '*'"
  type        = string
}

variable "statements" {
  description = "The statements to add to the inline policy"
  type = set(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = set(string)
    resources = set(string)
  }))
}
