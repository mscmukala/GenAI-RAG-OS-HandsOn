# Variables for OpenSearch Module

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "cluster_display_name" {
  description = "Display name for OpenSearch cluster"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for OpenSearch cluster"
  type        = string
}

variable "vcn_id" {
  description = "VCN ID for OpenSearch cluster"
  type        = string
}

variable "opensearch_version" {
  description = "OpenSearch version"
  type        = string
  default     = "2.11"
}

variable "master_node_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "master_node_host_ocpu_count" {
  description = "OCPUs for master nodes"
  type        = number
  default     = 1
}

variable "master_node_host_memory_gb" {
  description = "Memory in GB for master nodes"
  type        = number
  default     = 8
}

variable "data_node_count" {
  description = "Number of data nodes"
  type        = number
  default     = 2
}

variable "data_node_host_ocpu_count" {
  description = "OCPUs for data nodes"
  type        = number
  default     = 2
}

variable "data_node_host_memory_gb" {
  description = "Memory in GB for data nodes"
  type        = number
  default     = 16
}

variable "data_node_storage_gb" {
  description = "Storage in GB for data nodes"
  type        = number
  default     = 50
}

variable "admin_username" {
  description = "Admin username for OpenSearch"
  type        = string
  default     = "osadmin"
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for OpenSearch"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}