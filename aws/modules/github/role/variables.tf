variable "name" {
  type = string
}

variable "path" {
  type    = string
  default = "/"
}

variable "audience" {
  type    = string
  default = "sts.amazonaws.com"
}

// "<org_name>/<repo_name>"
variable "repository" {
  type = string
}

// to allow all branches use "ref:refs/heads/*", to allow everything from the repo use "*"
variable "scope" {
  type    = string
  default = "ref:refs/heads/main"
}

variable "statements" {
  type = set(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = set(string)
    resources = set(string)
  }))
}
