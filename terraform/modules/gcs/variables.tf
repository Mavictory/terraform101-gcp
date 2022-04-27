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

variable "website" {
  description = "Weather the bucket will be used as a website"
  type        = bool
  default     = false
}

variable "objects" {
  description = "Objects that will be added to the bucket"
  type        = map(any)
  default     = {}
}

variable "location" {
  description = "Location of the bucket"
  type        = string
  default     = "us-central1"
}