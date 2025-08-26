# Variables for GenAI Agent Module

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "agent_display_name" {
  description = "Display name for GenAI Agent"
  type        = string
}

variable "knowledge_base_name" {
  description = "Name for the knowledge base"
  type        = string
}

variable "opensearch_endpoint" {
  description = "OpenSearch cluster endpoint"
  type        = string
}

variable "opensearch_index_name" {
  description = "OpenSearch index name for embeddings"
  type        = string
  default     = "rag-embeddings"
}

variable "object_storage_bucket" {
  description = "Object Storage bucket name"
  type        = string
}

variable "object_storage_namespace" {
  description = "Object Storage namespace"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}