data "google_iam_policy" "admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:mavictory@itba.edu.ar",
    ]
  }
}