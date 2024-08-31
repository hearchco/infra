output "content" {
  value = data.http.downloader.response_body
  # sensitive = true # Not really sensitive, but we don't want to spam the console
}

output "content_base64" {
  value     = data.http.downloader.response_body_base64
  sensitive = true # Not really sensitive, but we don't want to spam the console
}

output "content_base64sha256" {
  value = base64sha256(data.http.downloader.response_body_base64)
}
