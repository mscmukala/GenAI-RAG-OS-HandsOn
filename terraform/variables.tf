# Variables for OCI GenAI Integration Lab

# OCI Provider Variables
variable "tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
}

# variable "user_ocid" {
#   description = "OCI User OCID"
#   type        = string
# }

# variable "fingerprint" {
#   description = "OCI API Key Fingerprint"
#   type        = string
# }

# variable "private_key_path" {
#   description = "Path to OCI API Private Key"
#   type        = string
# }

variable "region" {
  description = "OCI Region"
  type        = string
  default     = "us-chicago-1"
}

# variable "compartment_ocid" {
#   description = "OCI Compartment OCID for resources"
#   type        = string
# }

# Project Configuration
variable "project_name" {
  description = "Name of the project (used as prefix for resources)"
  type        = string
  default     = "genai-lab"
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  default     = "dev"
}

# Compartment module configuration
variable "compartment_name" {
  description = "Name of the compartment to create"
  type        = string
  default     = "genai-lab-compartment"
}

variable "compartment_description" {
  description = "Description of the compartment"
  type        = string
  default     = "Compartment for GenAI lab resources"
}

variable "compartment_parent_ocid" {
  description = "OCID of the parent compartment (usually tenancy OCID)"
  type        = string
}

variable "compartment_enable_delete" {
  description = "Enable deletion of the compartment (for lab/demo use only)"
  type        = bool
  default     = false
}

# Network Configuration
variable "vcn_cidr_blocks" {
  description = "CIDR blocks for VCN"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# OpenSearch Configuration
variable "opensearch_version" {
  description = "OpenSearch version"
  type        = string
  default     = "2.15"
}

variable "opensearch_master_node_count" {
  description = "Number of OpenSearch master nodes"
  type        = number
  default     = 1
}

variable "opensearch_master_node_ocpu" {
  description = "Number of OCPUs for OpenSearch master nodes"
  type        = number
  default     = 1
}

variable "opensearch_master_node_memory" {
  description = "Memory in GB for OpenSearch master nodes"
  type        = number
  default     = 8
}

variable "opensearch_data_node_count" {
  description = "Number of OpenSearch data nodes"
  type        = number
  default     = 2
}

variable "opensearch_data_node_ocpu" {
  description = "Number of OCPUs for OpenSearch data nodes"
  type        = number
  default     = 2
}

variable "opensearch_data_node_memory" {
  description = "Memory in GB for OpenSearch data nodes"
  type        = number
  default     = 16
}

variable "opensearch_data_node_storage" {
  description = "Storage in GB for OpenSearch data nodes"
  type        = number
  default     = 50
}

variable "opensearch_admin_username" {
  description = "OpenSearch admin username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "opensearch_admin_password" {
  description = "OpenSearch admin password"
  type        = string
  sensitive   = true
}

variable "opensearch_index_name" {
  description = "Name of the OpenSearch index for embeddings"
  type        = string
  default     = "rag-embeddings"
}

# Data Science Configuration
variable "notebook_shape" {
  description = "Shape for Data Science notebook"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "notebook_ocpus" {
  description = "Number of OCPUs for notebook"
  type        = number
  default     = 2
}

variable "notebook_memory_gb" {
  description = "Memory in GB for notebook"
  type        = number
  default     = 16
}

variable "notebook_storage_gb" {
  description = "Block storage size in GB for notebook"
  type        = number
  default     = 100
}

# GenAI Configuration
variable "genai_model_id" {
  description = "Model ID for GenAI service"
  type        = string
  default     = "cohere.command-r-plus"
}

variable "genai_embedding_model_id" {
  description = "Embedding model ID for GenAI service"
  type        = string
  default     = "cohere.embed-english-v3.0"
}

variable "genai_max_tokens" {
  description = "Maximum tokens for GenAI responses"
  type        = number
  default     = 2048
}

variable "genai_temperature" {
  description = "Temperature for GenAI model"
  type        = number
  default     = 0.7
}

# Object Storage Configuration
variable "enable_object_versioning" {
  description = "Enable versioning for Object Storage bucket"
  type        = bool
  default     = true
}

variable "enable_object_lifecycle" {
  description = "Enable lifecycle policies for Object Storage bucket"
  type        = bool
  default     = false
}

# Security Configuration
variable "enable_vault_integration" {
  description = "Enable OCI Vault for secrets management"
  type        = bool
  default     = false
}

variable "vault_ocid" {
  description = "OCI Vault OCID (if vault integration is enabled)"
  type        = string
  default     = ""
}

# Resource Tags
variable "freeform_tags" {
  description = "Freeform tags for resources"
  type        = map(string)
  default = {
    "Project"     = "OCI-GenAI-Integration"
    "ManagedBy"   = "Terraform"
    "Environment" = "Development"
  }
}

variable "defined_tags" {
  description = "Defined tags for resources"
  type        = map(string)
  default     = {}
}

# Feature Flags
variable "enable_monitoring" {
  description = "Enable OCI Monitoring for resources"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable OCI Logging for resources"
  type        = bool
  default     = true
}

variable "enable_backup" {
  description = "Enable automated backups"
  type        = bool
  default     = false
}

# Advanced Configuration
variable "chunk_size" {
  description = "Document chunk size for embeddings"
  type        = number
  default     = 1000
}

variable "chunk_overlap" {
  description = "Document chunk overlap for embeddings"
  type        = number
  default     = 200
}

variable "batch_size" {
  description = "Batch size for embedding processing"
  type        = number
  default     = 50
}

variable "similarity_threshold" {
  description = "Similarity threshold for RAG retrieval"
  type        = number
  default     = 0.7
}

variable "top_k_results" {
  description = "Number of top results to retrieve in RAG"
  type        = number
  default     = 5
}

variable "genai_top_p" {
  description = "Top-p sampling parameter for GenAI model"
  type        = number
  default     = 0.9
}

# OpenSearch Dashboard Configuration
variable "opensearch_enable_dashboard" {
  description = "Enable OpenSearch Dashboards"
  type        = bool
  default     = true
}

# Data Science Backup Configuration
variable "enable_notebook_backup" {
  description = "Enable automated backups for notebook sessions"
  type        = bool
  default     = false
}

# Object Storage Advanced Configuration
variable "object_storage_tier" {
  description = "Storage tier for Object Storage (Standard or Archive)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Archive"], var.object_storage_tier)
    error_message = "Storage tier must be either 'Standard' or 'Archive'."
  }
}

variable "enable_object_events" {
  description = "Enable object events for Object Storage bucket"
  type        = bool
  default     = false
}

# Security and Networking
variable "enable_bastion" {
  description = "Enable Bastion service for secure access"
  type        = bool
  default     = false
}

variable "enable_high_availability" {
  description = "Enable high availability configuration"
  type        = bool
  default     = false
}

# Monitoring and Notifications
variable "enable_notifications" {
  description = "Enable OCI Notifications service"
  type        = bool
  default     = false
}

variable "notification_email" {
  description = "Email address for notifications (required if notifications enabled)"
  type        = string
  default     = ""
}

# Backup and Recovery
variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 365
    error_message = "Backup retention days must be between 1 and 365."
  }
}

# Cost Management
variable "enable_auto_shutdown" {
  description = "Enable automatic shutdown during off-hours"
  type        = bool
  default     = false
}

variable "auto_shutdown_schedule" {
  description = "Cron schedule for auto-shutdown (UTC timezone)"
  type        = string
  default     = "0 20 * * 1-5"
}

variable "auto_startup_schedule" {
  description = "Cron schedule for auto-startup (UTC timezone)"
  type        = string
  default     = "0 8 * * 1-5"
}

# Advanced Configuration
variable "enable_debug" {
  description = "Enable debug mode for additional logging and outputs"
  type        = bool
  default     = false
}

variable "custom_user_data" {
  description = "Custom user data script for compute instances"
  type        = string
  default     = ""
}