variable "color" {
  type = string
  validation {
    condition     = var.color == "blue" || var.color == "green"
    error_message = "Color must be blue or green."
  }
}

variable "org_id" {
  type        = string
  description = "GCP organization ID"
}