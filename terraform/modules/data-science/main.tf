# Data Science Module for OCI GenAI Integration Lab

# Data Science Project
resource "oci_datascience_project" "main" {
  compartment_id = var.compartment_id
  display_name   = var.project_display_name
  description    = "Data Science project for GenAI RAG implementation with OpenSearch"
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "data-science"
  }
}

# Data Science Notebook Session
resource "oci_datascience_notebook_session" "main" {
  count = var.create_notebook_session ? 1 : 0
  
  compartment_id = var.compartment_id
  project_id     = oci_datascience_project.main.id
  display_name   = var.notebook_display_name
  
  notebook_session_config_details {
    shape                    = var.shape
    block_storage_size_in_gbs = var.block_storage_size_gb
    subnet_id                = var.subnet_id
    
    dynamic "notebook_session_shape_config_details" {
      for_each = contains(["VM.Standard.E4.Flex", "VM.Standard.E3.Flex", "VM.Standard3.Flex"], var.shape) ? [1] : []
      content {
        ocpus         = var.ocpus
        memory_in_gbs = var.memory_in_gbs
      }
    }
  }
  
  # Runtime configuration - Using conda environment
  notebook_session_runtime_config_details {
    custom_environment_variables = {
      "WORKSPACE_PREFIX" = "/home/datascience"
      "PROJECT_NAME"     = var.project_name
    }
    #change the git hub to the correct repo later- Srinivas
    notebook_session_git_config_details {
      notebook_session_git_repo_config_collection {
        url = "https://github.com/oracle-samples/oci-opensearch-samples.git"
      }
    }
  }
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "data-science"
  }
  
  lifecycle {
    ignore_changes = [
      notebook_session_runtime_config_details
    ]
  }
}

# Wait for notebook to be active
resource "time_sleep" "wait_for_notebook" {
  count = var.create_notebook_session ? 1 : 0
  depends_on = [oci_datascience_notebook_session.main]
  
  create_duration = "60s"
}

# Create initial notebook files
resource "null_resource" "setup_notebooks" {
  count = var.create_notebook_session ? 1 : 0
  depends_on = [time_sleep.wait_for_notebook]
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "Notebook session created successfully"
      echo "Session ID: ${oci_datascience_notebook_session.main[0].id}"
      echo "Please access the notebook and run the setup scripts"
    EOT
  }
}

# Outputs
output "project_id" {
  description = "Data Science project OCID"
  value       = oci_datascience_project.main.id
}

output "notebook_session_id" {
  description = "Notebook session OCID"
  value       = var.create_notebook_session ? oci_datascience_notebook_session.main[0].id : "Notebook session not created"
}

output "notebook_url" {
  description = "Notebook session URL"
  value       = var.create_notebook_session ? oci_datascience_notebook_session.main[0].notebook_session_url : "Notebook session not created"
}

output "notebook_state" {
  description = "Notebook session state"
  value       = var.create_notebook_session ? oci_datascience_notebook_session.main[0].state : "Notebook session not created"
}

output "notebook_created_by" {
  description = "User who created the notebook"
  value       = var.create_notebook_session ? oci_datascience_notebook_session.main[0].created_by : "Notebook session not created"
}