# ============================================================================
# OCI GenAI Hands-on Lab - Terraform Variables Example
# ============================================================================
# Copy this file to terraform.tfvars and update with your values
# ============================================================================

# ============================================================================
# REQUIRED: OCI Authentication
# ============================================================================



# Your OCI Tenancy OCID
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaavfoi6rf7tj6oktbwlqgslem6vz7pll666xi4domj2qqtneu5emka"



# Compartment where resources will be created
#compartment_ocid = "ocid1.compartment.oc1..aaaaaaaam7cux7uap4g46lb5jxuwl6r7girryogezjg45dvtxd3rj5ch5aia"

# Compartment module variables
compartment_name        = "genai-handson-compartment-user1"
compartment_description = "Compartment for GenAI Hands-on resources"
#root compartment ocid - "handson-root" on srinivas tenancy
compartment_parent_ocid = "ocid1.compartment.oc1..aaaaaaaaddi5fpoqf7bfplxo3tvfbfrpxsz2ake644ma6fg4iq2yckaodkya"

compartment_enable_delete = false

# OCI Region (must be us-chicago-1 for GenAI services)
region = "us-ashburn-1"

# ============================================================================
# REQUIRED: Security Configuration
# ============================================================================

# OpenSearch admin password (minimum 8 characters with uppercase, lowercase, and number)
opensearch_admin_password = "Asp2025$"

# ============================================================================
# OPTIONAL: Project Configuration
# ============================================================================

# Project name (used as prefix for all resources)
project_name = "genai-handson"

# Environment (dev, test, staging, prod)
environment = "dev"

# Availability domain number (1, 2, or 3)
#availability_domain_number = 1

# ============================================================================
# OPTIONAL: Network Configuration
# ============================================================================

# VCN CIDR blocks
vcn_cidr_blocks = ["10.0.0.0/16"]

# Public subnet CIDR
public_subnet_cidr = "10.0.1.0/24"

# Private subnet CIDR
private_subnet_cidr = "10.0.2.0/24"

# Enable IPv6
#enable_ipv6 = false

# Allowed ingress IPs for SSH (use your public IP for security)
#allowed_ingress_ips = ["0.0.0.0/0"]  # Change to your IP: ["YOUR.PUBLIC.IP.ADDRESS/32"]

# ============================================================================
# OPTIONAL: OpenSearch Configuration
# ============================================================================

# OpenSearch version
opensearch_version = "2.19.1"

# Master nodes configuration
opensearch_master_node_count  = 1  # Use 3 for production
opensearch_master_node_ocpu    = 1  # Increase for production
opensearch_master_node_memory  = 20  # Increase for production

# Data nodes configuration
opensearch_data_node_count   = 2  # Increase for larger datasets
opensearch_data_node_ocpu    = 2  # Increase for better performance
opensearch_data_node_memory  = 20 # Increase for larger datasets
opensearch_data_node_storage = 50 # Increase based on data volume

# OpenSearch admin username
opensearch_admin_username = "admin-os"

# Enable OpenSearch Dashboards
opensearch_enable_dashboard = true

# Index name for RAG embeddings
opensearch_index_name = "rag-embeddings"

# ============================================================================
# OPTIONAL: Data Science Configuration
# ============================================================================

# Notebook shape (VM.Standard.E4.Flex, VM.Standard.E3.Flex, VM.Standard3.Flex)
notebook_shape = "VM.Standard.E3.Flex"

# Notebook resources (for Flex shapes)
notebook_ocpus      = 1   # Number of OCPUs
notebook_memory_gb  = 8   # Memory in GB  
notebook_storage_gb = 50  # Block storage in GB

# Enable notebook backup
enable_notebook_backup = false

# ============================================================================
# OPTIONAL: GenAI Configuration
# ============================================================================

# Text generation model
genai_model_id = "cohere.command-r-plus"
# Options: "cohere.command-r-plus", "cohere.command-r", "meta.llama-3.1-70b-instruct"

# Embedding model
genai_embedding_model_id = "cohere.embed-english-v3.0"
# Options: "cohere.embed-english-v3.0", "cohere.embed-multilingual-v3.0"

# Model parameters
genai_max_tokens  = 2048  # Maximum tokens in response
genai_temperature = 0.7   # Temperature (0-1, lower is more deterministic)
genai_top_p      = 0.9   # Top-p sampling

# ============================================================================
# OPTIONAL: Object Storage Configuration
# ============================================================================

# Enable object versioning
enable_object_versioning = true

# Enable lifecycle policies
enable_object_lifecycle = false

# Storage tier (Standard or Archive)
object_storage_tier = "Standard"

# Enable object events
enable_object_events = false

# ============================================================================
# OPTIONAL: Document Processing Configuration
# ============================================================================

# Document chunking configuration
chunk_size    = 1000  # Size of text chunks
chunk_overlap = 200   # Overlap between chunks
batch_size    = 50    # Batch size for processing

# RAG retrieval configuration
similarity_threshold = 0.7  # Similarity threshold (0-1)
top_k_results       = 5    # Number of results to retrieve

# ============================================================================
# OPTIONAL: Security Configuration
# ============================================================================

# Enable OCI Vault integration
enable_vault_integration = false
vault_ocid = ""  # Required if vault integration is enabled

# Enable Bastion service
enable_bastion = false

# ============================================================================
# OPTIONAL: Monitoring and Logging
# ============================================================================

# Enable monitoring
enable_monitoring = true

# Enable logging
enable_logging = true

# Enable notifications
enable_notifications = false
notification_email = ""  # Required if notifications are enabled

# ============================================================================
# OPTIONAL: Backup and Recovery
# ============================================================================

# Enable automated backups
enable_backup = false

# Backup retention in days
backup_retention_days = 7

# ============================================================================
# OPTIONAL: Cost Management
# ============================================================================

# Enable auto-shutdown during off-hours
enable_auto_shutdown = false

# Auto-shutdown schedule (cron format in UTC)
auto_shutdown_schedule = "0 20 * * 1-5"  # 8 PM UTC weekdays

# Auto-startup schedule (cron format in UTC)
auto_startup_schedule = "0 8 * * 1-5"    # 8 AM UTC weekdays

# ============================================================================
# OPTIONAL: Tags
# ============================================================================

# Freeform tags for all resources
freeform_tags = {
  "Project"     = "OCI-GenAI-Handson"
  "ManagedBy"   = "Terraform"
  "Purpose"     = "GenAI-RAG-OS-HandsOn"
  "Owner"       = "Srinivas Mukala"
  "CostCenter"  = "0001"
}

# Defined tags (if using tag namespaces)
defined_tags = {}

# ============================================================================
# OPTIONAL: Advanced Configuration
# ============================================================================

# Enable debug mode
enable_debug = false

# Enable high availability
enable_high_availability = false

# Custom user data script
custom_user_data = ""

# ============================================================================
# DEPLOYMENT PROFILES
# ============================================================================
# Uncomment one of the following profiles for quick configuration

# --- MINIMAL PROFILE (Lowest Cost) ---
# opensearch_master_node_count = 1
# opensearch_master_node_ocpu  = 1
# opensearch_master_node_memory = 8
# opensearch_data_node_count   = 1
# opensearch_data_node_ocpu    = 1
# opensearch_data_node_memory  = 8
# opensearch_data_node_storage = 50
# notebook_ocpus               = 1
# notebook_memory_gb           = 8
# notebook_storage_gb          = 50

# --- DEVELOPMENT PROFILE (Balanced) ---
# opensearch_master_node_count = 1
# opensearch_master_node_ocpu  = 1
# opensearch_master_node_memory = 8
# opensearch_data_node_count   = 2
# opensearch_data_node_ocpu    = 2
# opensearch_data_node_memory  = 16
# opensearch_data_node_storage = 100
# notebook_ocpus               = 2
# notebook_memory_gb           = 16
# notebook_storage_gb          = 100

# --- PRODUCTION PROFILE (High Performance) ---
# opensearch_master_node_count = 3
# opensearch_master_node_ocpu  = 2
# opensearch_master_node_memory = 16
# opensearch_data_node_count   = 3
# opensearch_data_node_ocpu    = 4
# opensearch_data_node_memory  = 32
# opensearch_data_node_storage = 500
# notebook_ocpus               = 4
# notebook_memory_gb           = 32
# notebook_storage_gb          = 200
# enable_high_availability     = true
# enable_backup               = true
# enable_monitoring           = true
# enable_logging             = true