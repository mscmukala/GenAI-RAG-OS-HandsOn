# ============================================================================
# OCI GenAI Hands-on Lab - Version Constraints
# ============================================================================
# This file defines the version requirements for Terraform and providers.
# ============================================================================

terraform {
  # Terraform Version Requirement
  required_version = ">= 1.0.0, < 2.0.0"
  
  # Provider Version Requirements
#---------------------------------------------------------------------------
# Provider Version Requirements
# -----------------------------------------------------------------------------
# This block specifies the required providers and their version constraints for
# this Terraform configuration. Each provider is pinned to a specific version
# range to ensure compatibility and stability.
#
# Providers:
# - oci:    Oracle Cloud Infrastructure resources (OpenSearch, Data Science, GenAI, etc.)
# - local:  For creating/managing local files
# - null:   For provisioners and resource dependencies
# - time:   For time-based waits and delays
# - archive: For creating zip files and archives
# - random: For generating random values
# -----------------------------------------------------------------------------
}