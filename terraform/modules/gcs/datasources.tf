data "google_dns_managed_zone" "public" {
  project = var.project
  name = "mvictory"
}