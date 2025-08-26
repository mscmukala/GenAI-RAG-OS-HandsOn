
variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "namespace" {
  description = "Object Storage namespace"
  type        = string
}

variable "bucket_name" {
  description = "Name for the Object Storage bucket"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}