variable "release_repository" {
  description = "The GitHub repository to download the release from"
  type        = string
}

variable "release_repository_owner" {
  description = "The owner of the GitHub repository"
  type        = string
}

variable "release_tag" {
  description = "The release tag on the GitHub repository"
  type        = string
}

variable "release_asset_name" {
  description = "The name of the asset to download from the release"
  type        = string
}
