# Variables for Data Science Module

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "project_display_name" {
  description = "Display name for Data Science project"
  type        = string
}

variable "notebook_display_name" {
  description = "Display name for notebook session"
  type        = string
}

variable "create_notebook_session" {
  description = "Whether to create the notebook session"
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Subnet ID for notebook session"
  type        = string
}

variable "shape" {
  description = "Compute shape for notebook session"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "ocpus" {
  description = "Number of OCPUs for notebook"
  type        = number
  default     = 2
}

variable "memory_in_gbs" {
  description = "Memory in GB for notebook"
  type        = number
  default     = 16
}

variable "block_storage_size_gb" {
  description = "Block storage size in GB"
  type        = number
  default     = 100
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}