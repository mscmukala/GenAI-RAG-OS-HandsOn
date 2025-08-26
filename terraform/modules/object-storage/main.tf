# Object Storage Module for OCI GenAI Integration Lab

# Object Storage Bucket
resource "oci_objectstorage_bucket" "main" {
  compartment_id = var.compartment_id
  namespace      = var.namespace
  name           = var.bucket_name
  access_type    = "NoPublicAccess"
  
  # Enable versioning for data protection
  versioning = "Enabled"
  
  # Storage tier
  storage_tier = "Standard"
  
  # Auto-tiering (move to Archive after 90 days of inactivity)
  auto_tiering = "InfrequentAccess"
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "object-storage"
    "Purpose" = "Document storage for RAG"
  }
}

# Create folders/prefixes in the bucket
resource "oci_objectstorage_object" "documents_folder" {
  namespace   = var.namespace
  bucket      = oci_objectstorage_bucket.main.name
  object      = "documents/.keep"
  content     = "# Documents folder for RAG processing"
  content_type = "text/plain"
}

resource "oci_objectstorage_object" "embeddings_folder" {
  namespace   = var.namespace
  bucket      = oci_objectstorage_bucket.main.name
  object      = "embeddings/.keep"
  content     = "# Embeddings storage folder"
  content_type = "text/plain"
}

resource "oci_objectstorage_object" "models_folder" {
  namespace   = var.namespace
  bucket      = oci_objectstorage_bucket.main.name
  object      = "models/.keep"
  content     = "# Models storage folder"
  content_type = "text/plain"
}

# Sample documents for testing
resource "oci_objectstorage_object" "sample_doc" {
  namespace   = var.namespace
  bucket      = oci_objectstorage_bucket.main.name
  object      = "documents/README.md"
  content     = <<-EOT
    # Sample Document for RAG Testing
    
    This is a sample document uploaded to demonstrate the RAG pipeline.
    
    ## About OCI GenAI
    Oracle Cloud Infrastructure (OCI) Generative AI is a fully managed service that provides access to large language models.
    
    ## About OpenSearch
    OpenSearch is a distributed search and analytics engine that supports vector search capabilities.
    
    ## Integration Benefits
    - Scalable document processing
    - Real-time similarity search
    - Conversational AI capabilities
    - Enterprise-grade security
    
    ## Use Cases
    1. Customer support automation
    2. Document search and retrieval
    3. Knowledge base Q&A
    4. Content generation
  EOT
  content_type = "text/markdown"
}

# Lifecycle policy for cost optimization (optional)
resource "oci_objectstorage_object_lifecycle_policy" "main" {
  namespace = var.namespace
  bucket    = oci_objectstorage_bucket.main.name
  
  rules {
    action      = "ARCHIVE"
    is_enabled  = true
    name        = "archive-old-embeddings"
    time_amount = 90
    time_unit   = "DAYS"
    
    object_name_filter {
      inclusion_prefixes = ["embeddings/"]
    }
  }
  
  rules {
    action      = "DELETE"
    is_enabled  = true
    name        = "delete-temp-files"
    time_amount = 7
    time_unit   = "DAYS"
    
    object_name_filter {
      inclusion_prefixes = ["temp/"]
    }
  }
}

# Pre-authenticated request for temporary access (optional)
resource "oci_objectstorage_preauthrequest" "upload_documents" {
  namespace    = var.namespace
  bucket       = oci_objectstorage_bucket.main.name
  name         = "document-upload-${formatdate("YYYY-MM-DD", timestamp())}"
  access_type  = "ObjectWrite"
  time_expires = timeadd(timestamp(), "168h") # 7 days
  
  object_name = "documents/"
}

# Outputs
output "bucket_name" {
  description = "Object Storage bucket name"
  value       = oci_objectstorage_bucket.main.name
}

output "bucket_namespace" {
  description = "Object Storage namespace"
  value       = var.namespace
}

output "bucket_compartment_id" {
  description = "Bucket compartment ID"
  value       = oci_objectstorage_bucket.main.compartment_id
}

output "bucket_created_date" {
  description = "Bucket creation date"
  value       = oci_objectstorage_bucket.main.time_created
}

output "bucket_etag" {
  description = "Bucket ETag"
  value       = oci_objectstorage_bucket.main.etag
}

output "upload_par_url" {
  description = "Pre-authenticated request URL for uploads"
  value       = "https://objectstorage.${var.namespace}.oraclecloud.com${oci_objectstorage_preauthrequest.upload_documents.access_uri}"
  sensitive   = true
}