# ---------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------

variable "bucket_name" {
  description = "Bucket name"
  type        = string
  default     = "test-bucket-itba-cloud-computing"
}

variable "path" {
  description = "Path to website files"
  type        = string
  default     = "../../resources"
}