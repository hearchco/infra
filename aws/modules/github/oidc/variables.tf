variable "url" {
  type    = string
  default = "https://token.actions.githubusercontent.com"
}

variable "audience" {
  type    = string
  default = "sts.amazonaws.com"
}

variable "thumbprint_list" {
  type    = list(string)
  default = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}
