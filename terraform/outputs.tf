# Terraform Outputs for OCI GenAI Integration Lab

# Stack Information
output "stack_version" {
  description = "Version of the deployed stack"
  value       = "1.0.0"
}

output "deployment_timestamp" {
  description = "Deployment timestamp"
  value       = timestamp()
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "region" {
  description = "OCI Region"
  value       = var.region
}

# Network Outputs
output "vcn_id" {
  description = "VCN OCID"
  value       = module.network.vcn_id
}

output "public_subnet_id" {
  description = "Public subnet OCID"
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet OCID"
  value       = module.network.private_subnet_id
}

# OpenSearch Outputs - Removed
# output "opensearch_cluster_id" {
#   description = "OpenSearch cluster OCID"
#   value       = "OpenSearch module removed"
# }

# output "opensearch_endpoint" {
#   description = "OpenSearch API endpoint"
#   value       = "OpenSearch module removed"
# }

# output "opensearch_dashboard_url" {
#   description = "OpenSearch Dashboards URL"
#   value       = "OpenSearch module removed"
# }

# output "opensearch_private_ip" {
#   description = "OpenSearch cluster private IP"
#   value       = "OpenSearch module removed"
#   sensitive   = true
# }

# Data Science Outputs (Data Science module disabled)
output "data_science_project_id" {
  description = "Data Science project OCID"
  value       = "Data Science module disabled - create manually if needed"
}

output "notebook_session_id" {
  description = "Data Science notebook session OCID"
  value       = "Data Science module disabled - create manually if needed"
}

output "notebook_url" {
  description = "Data Science notebook session URL"
  value       = "Data Science module disabled - create manually if needed"
}

# Object Storage Outputs (Object Storage Module Disabled)
output "bucket_name" {
  description = "Object Storage bucket name (Object Storage module disabled - create manually if needed)"
  value       = "Object Storage module disabled - create manually if needed"
}

output "bucket_namespace" {
  description = "Object Storage namespace"
  value       = data.oci_objectstorage_namespace.ns.namespace
}

output "bucket_url" {
  description = "Object Storage bucket URL (Object Storage module disabled - create manually if needed)"
  value       = "Object Storage module disabled - create manually if needed"
}

# GenAI Agent Outputs (GenAI Agent Module Disabled)
output "genai_agent_id" {
  description = "GenAI Agent OCID (GenAI Agent module disabled - create manually if needed)"
  value       = "GenAI Agent module disabled - create manually if needed"
}

output "genai_agent_endpoint" {
  description = "GenAI Agent endpoint (GenAI Agent module disabled - create manually if needed)"
  value       = "GenAI Agent module disabled - create manually if needed"
}

output "genai_knowledge_base_id" {
  description = "GenAI Knowledge Base OCID (GenAI Agent module disabled - create manually if needed)"
  value       = "GenAI Agent module disabled - create manually if needed"
}

# Connection Instructions
output "connection_instructions" {
  description = "Instructions for connecting to services"
  value = <<-EOT
    
    ========================================
    CONNECTION INSTRUCTIONS
    ========================================
    
    Infrastructure deployed contains only:
    - Compartment and networking (VCN, subnets, gateways)
    
    All service modules have been removed:
    - OpenSearch module: REMOVED
    - Data Science module: DISABLED  
    - Object Storage module: DISABLED
    - GenAI Agent module: DISABLED
    
    Create services manually in OCI Console if needed.
    
    ========================================
  EOT
 sensitive = true
}

# Configuration File Output
output "notebook_configuration" {
  description = "Configuration for environment"
  value = {
    compartment_id = module.compartment.id
    project_name   = var.project_name
    region         = var.region
    vcn_id         = module.network.vcn_id
    public_subnet  = module.network.public_subnet_id
    private_subnet = module.network.private_subnet_id
    note          = "OpenSearch module removed - infrastructure contains only compartment and networking"
  }
  sensitive = true
}