# Main Terraform Configuration for OCI GenAI Integration Lab
# This creates all necessary resources for the hands-on lab

terraform {
  required_version = ">= 1.0"
}

# Data Sources
#data "oci_identity_availability_domains" "ads" {
  #compartment_id = var.tenancy_ocid
#}
module "compartment" {
  source                = "./modules/compartment"
  name                  = var.compartment_name
  description           = var.compartment_description
  parent_compartment_id = var.compartment_parent_ocid
  enable_delete         = var.compartment_enable_delete
}

# Data source for Object Storage namespace
data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.tenancy_ocid
}
# Networking Module
module "network" {
  source = "./modules/network"
  compartment_id     = module.compartment.id
  vcn_display_name   = "${var.project_name}-vcn"
  vcn_cidr_blocks    = var.vcn_cidr_blocks
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  project_name       = var.project_name
  region             = var.region
}

# Object Storage Module - Disabled for cleanup
# module "object_storage" {
#   source = "./modules/object-storage"
#   compartment_id   = module.compartment.id
#   bucket_name      = "${var.project_name}-data-bucket"
#   project_name     = var.project_name
#   namespace        = data.oci_objectstorage_namespace.ns.namespace
# }

# OpenSearch Module - Removed
# module "opensearch" {
#   source = "./modules/opensearch"
#   compartment_id              = module.compartment.id
#   cluster_display_name        = "${var.project_name}-opensearch"
#   subnet_id                   = module.network.private_subnet_id
#   vcn_id                      = module.network.vcn_id
#   master_node_count          = var.opensearch_master_node_count
#   master_node_host_ocpu_count = var.opensearch_master_node_ocpu
#   master_node_host_memory_gb = var.opensearch_master_node_memory
#   data_node_count            = var.opensearch_data_node_count
#   data_node_host_ocpu_count  = var.opensearch_data_node_ocpu
#   data_node_host_memory_gb   = var.opensearch_data_node_memory
#   data_node_storage_gb       = var.opensearch_data_node_storage
#   opensearch_version         = var.opensearch_version
#   admin_password             = var.opensearch_admin_password
#   project_name               = var.project_name
# }

# Data Science Module - Disabled for cleanup
# module "data_science" {
#   source = "./modules/data-science"
#   compartment_id          = module.compartment.id
#   project_display_name    = "${var.project_name}-ds-project"
#   notebook_display_name   = "${var.project_name}-notebook"
#   subnet_id              = module.network.private_subnet_id
#   shape                  = var.notebook_shape
#   ocpus                  = var.notebook_ocpus
#   memory_in_gbs          = var.notebook_memory_gb
#   block_storage_size_gb  = var.notebook_storage_gb
#   project_name           = var.project_name
#   
#   # Disable notebook session creation
#   create_notebook_session = false
# }

# GenAI Agent Module - Disabled for cleanup
# module "genai_agent" {
#   source = "./modules/genai-agent"
#
#   compartment_id           = module.compartment.id
#   agent_display_name       = "${var.project_name}-rag-agent"
#   knowledge_base_name      = "${var.project_name}-knowledge-base"
#   opensearch_endpoint      = module.opensearch.cluster_endpoint
#   opensearch_index_name    = var.opensearch_index_name
#   object_storage_bucket    = "${var.project_name}-data-bucket-manual"  # Manual bucket reference
#   object_storage_namespace = data.oci_objectstorage_namespace.ns.namespace
#   project_name            = var.project_name
#   
#   depends_on = [
#     module.opensearch
#     # module.object_storage  # Disabled - create bucket manually if needed
#   ]
# }

# Object Storage policy - Disabled
# resource "oci_identity_policy" "object_storage_policy" {
#   compartment_id = var.tenancy_ocid
#   name           = "object-storage-policy"
#   description    = "Policy for Object Storage service principal"
#   statements = [
#     "Allow service objectstorage-${var.region} to manage object-family in compartment id ${module.compartment.id}"
#   ]
# }
  
# Data Science policies - Disabled
# resource "oci_identity_policy" "data_science_policies" {
#   compartment_id = var.tenancy_ocid
#   name           = "${var.project_name}-data-science-policies"
#   description    = "Policies for Data Science service"
#   statements = [
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage data-science-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage object-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to use opensearch-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to use log-content in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to read virtual-network-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage data-science-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to use object-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to read repos in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage generative-ai-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage vaults in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage keys in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage secrets in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.data_science_dynamic_group.name} to manage secret-family in compartment id ${module.compartment.id}"
#     # Removed genai-agent-family policy as GenAI agent module is disabled
#   ]
# }

# OpenSearch policies - Removed
# resource "oci_identity_policy" "opensearch_policies" {
#   compartment_id = var.tenancy_ocid
#   name           = "${var.project_name}-opensearch-policies"
#   description    = "Policies for OpenSearch service"
#   statements = [
#     "Allow service opensearch to manage vnics in compartment id ${module.compartment.id}",
#     "Allow service opensearch to use subnets in compartment id ${module.compartment.id}",
#     "Allow service opensearch to use network-security-groups in compartment id ${module.compartment.id}",
#     "Allow service opensearch to manage vcns in compartment id ${module.compartment.id}"
#   ]
# }

# Create a dynamic group for GenAI - Disabled 
# resource "oci_identity_dynamic_group" "genai_dynamic_group" {
#   compartment_id = var.tenancy_ocid
#   name           = "${var.project_name}-genai-dynamic-group"
#   description    = "Dynamic group for GenAI resources"
#   matching_rule  = "Any {resource.type = 'genaiagent', resource.compartment.id = '${module.compartment.id}'}"
# }

# IAM policy for the dynamic group - Disabled
# resource "oci_identity_policy" "genai_policies" {
#   compartment_id = var.tenancy_ocid
#   name           = "${var.project_name}-genai-policies"
#   description    = "Policies for GenAI dynamic group"
#   statements = [
#     "Allow dynamic-group ${oci_identity_dynamic_group.genai_dynamic_group.name} to read object-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.genai_dynamic_group.name} to use opensearch-family in compartment id ${module.compartment.id}",
#     "Allow dynamic-group ${oci_identity_dynamic_group.genai_dynamic_group.name} to manage generative-ai-family in compartment id ${module.compartment.id}"
#   ]
# }


# Dynamic Group for Data Science - Disabled
# resource "oci_identity_dynamic_group" "data_science_dynamic_group" {
#   compartment_id = var.tenancy_ocid
#   name           = "${var.project_name}-data-science-dg"
#   description    = "Dynamic group for Data Science notebook sessions"
#   matching_rule = "Any {resource.type = 'datasciencenotebooksession', resource.compartment.id = '${module.compartment.id}'}"
# }

# Tags for resource organization (commented out due to permission requirements)
# Uncomment if you have appropriate IAM permissions for tag management
# resource "oci_identity_tag_namespace" "project_tags" {
#   compartment_id = module.compartment.id
#   description    = "Tag namespace for ${var.project_name}"
#   name           = var.project_name
# }

# resource "oci_identity_tag" "environment" {
#   tag_namespace_id = oci_identity_tag_namespace.project_tags.id
#   name             = "environment"
#   description      = "Environment tag"
# }

# resource "oci_identity_tag" "project" {
#   tag_namespace_id = oci_identity_tag_namespace.project_tags.id
#   name             = "project"
#   description      = "Project tag"
# }

# Local file outputs for configuration
resource "local_file" "notebook_config" {
  filename = "${path.module}/../config/notebook_config.json"
  content = jsonencode({
    bucket_name        = "manual-bucket-creation-needed"  # Manual bucket reference
    namespace          = data.oci_objectstorage_namespace.ns.namespace
    compartment_id     = module.compartment.id
    genai_endpoint     = "https://inference.generativeai.${var.region}.oci.oraclecloud.com"
    project_name       = var.project_name
    note              = "OpenSearch module removed - Data Science, Object Storage, and GenAI Agent modules also disabled"
  })
}

# Resource Manager Stack Configuration
resource "local_file" "resource_manager_zip" {
  filename = "${path.module}/../stack.zip"
  #content  = data.archive_file.stack_zip.output_base64
  content = data.archive_file.stack_zip.output_base64sha256

}

data "archive_file" "stack_zip" {
  type        = "zip"
  output_path = "${path.module}/../stack.zip"
  
  source {
    content  = file("${path.module}/main.tf")
    filename = "main.tf"
  }
  
  source {
    content  = file("${path.module}/variables.tf")
    filename = "variables.tf"
  }
  
  source {
    content  = file("${path.module}/outputs.tf")
    filename = "outputs.tf"
  }
  
  source {
    content  = file("${path.module}/provider.tf")
    filename = "provider.tf"
  }
  
  source {
    content  = file("${path.module}/versions.tf")
    filename = "versions.tf"
  }
  
  source {
    content  = file("${path.module}/resource-manager/schema.yaml")
    filename = "schema.yaml"
  }
}