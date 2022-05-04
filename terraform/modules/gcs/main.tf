# ---------------------------------------------------------------------------
# Main resources - baseline configuration for Cloud Storage website
# ---------------------------------------------------------------------------

resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = var.location
  project       = var.project
  force_destroy = true

  dynamic "website" {
    for_each = var.website ? [1] : []
    content {
      main_page_suffix = "index.html"
      not_found_page   = "error.html"
    }
  }

  dynamic "cors" {
    for_each = var.website ? [1] : []
    content {
      origin          = ["*"]
      method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      response_header = ["*"]
      max_age_seconds = 3600
    }
  }
   
  # labels =  {
  #   managed-by = "Mariano Victory"
  #   project    = "test-mavictory"
  #   subject    = "Cloud Computing"
  #   created-by = "terraform"
  # }
}
# ----------------
# 2- OBJECT ACL
# ----------------

resource "google_storage_default_object_access_control" "public_rule" {
  count = var.website ? 1 : 0
  bucket = google_storage_bucket.this.name
  role   = "READER"
  entity = "allUsers"
}

# ------------------------------------------------------------------------------
# ADD BUCKET OBJECTS
# ------------------------------------------------------------------------------

resource "google_storage_bucket_object" "assets" {
  for_each = try(var.objects, {})

  bucket        = google_storage_bucket.this.name
  name          = replace(each.value.filename, "html/", "") # remote path
  source        = format("${var.path}/%s", each.value.filename) # where is the file located
  content_type  = each.value.content_type
  storage_class = try(each.value.storage_class, "STANDARD")

  depends_on = [
    google_storage_default_object_access_control.public_rule,
  ]
}
