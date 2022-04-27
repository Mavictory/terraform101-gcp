# ---------------------------------------------------------------------------
# Main resources - baseline configuration for Cloud Storage website
# ---------------------------------------------------------------------------

resource "google_storage_bucket" "static-site" {
  provider      = google-beta
  name          = local.gcs.bucket_name
  location      = "us-central1"
  force_destroy = true

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
    managed-by = "Mariano Victory"
    project    = "test-mavictory"
    subject    = "Cloud Computing"
    created-by = "terraform"
  }
}
# ----------------
# 2- OBJECT ACL
# ----------------

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static-site.name
  role   = "READER"
  entity = "allUsers"
}

# ----------------------
# 3- BUCKET IAM POLICY
# ----------------------

resource "google_storage_bucket_iam_policy" "policy" {
  bucket = google_storage_bucket.static-site.name
  policy_data = data.google_iam_policy.admin.policy_data
    depends_on = [
    google_storage_default_object_access_control.public_rule,
  ]
}

# ------------------------------------------------------------------------------
# ADD BUCKET OBJECTS
# ------------------------------------------------------------------------------

resource "google_storage_bucket_object" "assets" {
  for_each = local.gcs.objects

  bucket        = google_storage_bucket.static-site.name
  name          = replace(each.value.filename, "html/", "") # remote path
  source        = format("${var.path}/%s", each.value.filename) # where is the file located
  content_type  = each.value.content_type
  storage_class = try(each.value.storage_class, "STANDARD")

  depends_on = [
    google_storage_default_object_access_control.public_rule,
  ]
}
