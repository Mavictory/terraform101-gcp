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
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static-site.name
  role   = "READER"
  entity = "allUsers"
}

# ------------------------------------------------------------------------------
# ADD BUCKET OBJECTS
# ------------------------------------------------------------------------------

resource "google_storage_bucket_object" "main_page" {
  name   = "index.html"
  source = "../../resources/html/index.html"
  bucket = google_storage_bucket.static-site.name
}

resource "google_storage_bucket_object" "error_page" {
  name   = "error.html"
  source = "../../resources/html/error.html"
  bucket = google_storage_bucket.static-site.name
}

resource "google_storage_bucket_object" "image1" {
  name   = "images/image1.png"
  source = "../../resources/images/image1.png"
  bucket = google_storage_bucket.static-site.name
}

resource "google_storage_bucket_object" "image2" {
  name   = "images/image2.jpg"
  source = "../../resources/images/image2.jpg"
  bucket = google_storage_bucket.static-site.name
}