variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-north1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "europe-north1-b"
}

variable "student_id" {
  description = "Your student identifier"
  type        = string
}
