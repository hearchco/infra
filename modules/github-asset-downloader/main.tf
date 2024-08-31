data "github_release" "release" {
  repository  = var.release_repository
  owner       = var.release_repository_owner
  retrieve_by = "tag"
  release_tag = var.release_tag
}

data "http" "downloader" {
  url = [for asset in data.github_release.release.assets : asset.browser_download_url if asset.name == var.release_asset_name][0]
}
