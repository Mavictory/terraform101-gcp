# ---------------------------------------------------------------------------
# Main resources - baseline configuration for Cloud Storage website
# ---------------------------------------------------------------------------

resource "google_storage_bucket" "static-site" {
  provider      = google-beta
  name          = var.bucket_name
  location      = "us-central1"
  force_destroy = true
  storage_class = "STANDARD"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  labels =  {
    managed-by = "mariano-victory"
    project    = "test-mavictory"
    subject    = "cloud-computing"
    created-by = "terraform"
  }
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static-site.name
  role   = "READER"
  entity = "allUsers"
}

# ------------------------------------------------------------------------------
# ADD BUCKET OBJECTS
# ------------------------------------------------------------------------------

resource "google_storage_bucket_object" "html" {
  for_each = toset(["index.html", "error.html"])
  name   = each.key
  source = "${var.path}/html/${each.key}"
  bucket = google_storage_bucket.static-site.name
  depends_on = [google_storage_default_object_access_control.public_rule]
}

resource "google_storage_bucket_object" "assets" {
  for_each = toset(["image1.png", "image2.jpg"])
  name   = format("resources/%s", each.key)
  source = format("%s/images/%s", var.path, each.key)
  bucket = google_storage_bucket.static-site.name
  depends_on = [google_storage_default_object_access_control.public_rule]
}
