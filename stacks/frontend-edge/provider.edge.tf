provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"
  alias   = "edge"
}
