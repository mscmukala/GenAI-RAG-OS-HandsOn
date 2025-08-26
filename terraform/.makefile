# ============================================================================
# OCI GenAI Hands-on Lab - Makefile
# ============================================================================
# Simplifies common Terraform operations for the lab infrastructure
# Usage: make <target>
# ============================================================================

# Variables
SHELL := /bin/bash
.DEFAULT_GOAL := help
TERRAFORM := terraform
PYTHON := python3
OCI := oci

# Color output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Check if terraform.tfvars exists
TFVARS_FILE := terraform.tfvars
TFVARS_EXISTS := $(shell test -f $(TFVARS_FILE) && echo 1 || echo 0)

# ============================================================================
# Help Target
# ============================================================================

.PHONY: help
help: ## Show this help message
	@echo "============================================================================"
	@echo "                    OCI GenAI Hands-on Lab - Terraform"
	@echo "============================================================================"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "Quick Start:"
	@echo "  1. make setup        - Initial setup and configuration"
	@echo "  2. make plan         - Review infrastructure changes"
	@echo "  3. make deploy       - Deploy all infrastructure"
	@echo "  4. make test         - Test deployed services"
	@echo "  5. make destroy      - Clean up all resources"
	@echo ""

# ============================================================================
# Setup and Configuration
# ============================================================================

.PHONY: setup
setup: check-requirements create-tfvars init ## Complete initial setup
	@echo "$(GREEN)✓ Setup complete!$(NC)"
	@echo "Next step: Edit terraform.tfvars with your OCI credentials"

.PHONY: check-requirements
check-requirements: ## Check required tools are installed
	@echo "$(BLUE)Checking requirements...$(NC)"
	@command -v $(TERRAFORM) >/dev/null 2>&1 || { echo "$(RED)✗ Terraform is not installed$(NC)"; exit 1; }
	@command -v $(OCI) >/dev/null 2>&1 || { echo "$(RED)✗ OCI CLI is not installed$(NC)"; exit 1; }
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo "$(RED)✗ Python3 is not installed$(NC)"; exit 1; }
	@echo "$(GREEN)✓ All requirements met$(NC)"

.PHONY: create-tfvars
create-tfvars: ## Create terraform.tfvars from example
ifeq ($(TFVARS_EXISTS),0)
	@echo "$(BLUE)Creating terraform.tfvars from example...$(NC)"
	@cp terraform.tfvars.example terraform.tfvars
	@echo "$(GREEN)✓ Created terraform.tfvars$(NC)"
	@echo "$(YELLOW)! Please edit terraform.tfvars with your values$(NC)"
else
	@echo "$(YELLOW)terraform.tfvars already exists$(NC)"
endif

.PHONY: validate-config
validate-config: ## Validate OCI configuration
	@echo "$(BLUE)Validating OCI configuration...$(NC)"
	@$(OCI) iam region list > /dev/null 2>&1 || { echo "$(RED)✗ OCI CLI not configured properly$(NC)"; exit 1; }
	@echo "$(GREEN)✓ OCI configuration valid$(NC)"

# ============================================================================
# Terraform Operations
# ============================================================================

.PHONY: init
init: ## Initialize Terraform
	@echo "$(BLUE)Initializing Terraform...$(NC)"
	@$(TERRAFORM) init -upgrade
	@echo "$(GREEN)✓ Terraform initialized$(NC)"

.PHONY: validate
validate: ## Validate Terraform configuration
	@echo "$(BLUE)Validating Terraform configuration...$(NC)"
	@$(TERRAFORM) validate
	@echo "$(GREEN)✓ Configuration is valid$(NC)"

.PHONY: plan
plan: init validate ## Plan infrastructure changes
	@echo "$(BLUE)Planning infrastructure changes...$(NC)"
	@$(TERRAFORM) plan -out=tfplan
	@echo "$(GREEN)✓ Plan saved to tfplan$(NC)"

.PHONY: deploy
deploy: plan ## Deploy infrastructure (with confirmation)
	@echo "$(YELLOW)Ready to deploy infrastructure$(NC)"
	@read -p "Continue? (y/n): " -n 1 -r; \
	echo ""; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(BLUE)Deploying infrastructure...$(NC)"; \
		$(TERRAFORM) apply tfplan; \
		echo "$(GREEN)✓ Infrastructure deployed successfully$(NC)"; \
		$(MAKE) show-outputs; \
	else \
		echo "$(YELLOW)Deployment cancelled$(NC)"; \
	fi

.PHONY: deploy-auto
deploy-auto: plan ## Deploy infrastructure without confirmation
	@echo "$(BLUE)Deploying infrastructure...$(NC)"
	@$(TERRAFORM) apply -auto-approve
	@echo "$(GREEN)✓ Infrastructure deployed successfully$(NC)"
	@$(MAKE) show-outputs

.PHONY: destroy
destroy: ## Destroy all infrastructure (with confirmation)
	@echo "$(RED)WARNING: This will destroy all infrastructure!$(NC)"
	@read -p "Type 'DELETE' to confirm: " confirm; \
	if [ "$$confirm" = "DELETE" ]; then \
		echo "$(BLUE)Destroying infrastructure...$(NC)"; \
		$(TERRAFORM) destroy -auto-approve; \
		echo "$(GREEN)✓ Infrastructure destroyed$(NC)"; \
	else \
		echo "$(YELLOW)Destruction cancelled$(NC)"; \
	fi

.PHONY: refresh
refresh: ## Refresh Terraform state
	@echo "$(BLUE)Refreshing Terraform state...$(NC)"
	@$(TERRAFORM) refresh
	@echo "$(GREEN)✓ State refreshed$(NC)"

# ============================================================================
# Output and Information
# ============================================================================

.PHONY: outputs
outputs: ## Show Terraform outputs
	@$(TERRAFORM) output

.PHONY: show-outputs
show-outputs: ## Show formatted outputs
	@echo ""
	@echo "$(GREEN)============================================================================$(NC)"
	@echo "$(GREEN)                        Deployment Outputs$(NC)"
	@echo "$(GREEN)============================================================================$(NC)"
	@echo ""
	@echo "$(BLUE)Notebook URL:$(NC)"
	@$(TERRAFORM) output -raw notebook_session_url 2>/dev/null || echo "Not available"
	@echo ""
	@echo "$(BLUE)OpenSearch Endpoint:$(NC)"
	@$(TERRAFORM) output -raw opensearch_api_endpoint 2>/dev/null || echo "Not available"
	@echo ""
	@echo "$(BLUE)Bucket Name:$(NC)"
	@$(TERRAFORM) output -raw bucket_name 2>/dev/null || echo "Not available"
	@echo ""
	@echo "$(GREEN)============================================================================$(NC)"

.PHONY: costs
costs: ## Show estimated monthly costs
	@echo "$(BLUE)Estimated Monthly Costs:$(NC)"
	@$(TERRAFORM) output estimated_monthly_cost 2>/dev/null || echo "Run 'make deploy' first"

.PHONY: connection-info
connection-info: ## Show connection instructions
	@$(TERRAFORM) output -raw connection_instructions 2>/dev/null || echo "Run 'make deploy' first"

# ============================================================================
# Testing and Validation
# ============================================================================

.PHONY: test
test: test-opensearch test-notebook test-storage ## Test all deployed services

.PHONY: test-opensearch
test-opensearch: ## Test OpenSearch connection
	@echo "$(BLUE)Testing OpenSearch connection...$(NC)"
	@ENDPOINT=$$($(TERRAFORM) output -raw opensearch_api_endpoint 2>/dev/null); \
	if [ -n "$$ENDPOINT" ]; then \
		curl -k -s -o /dev/null -w "%{http_code}" $$ENDPOINT/_cluster/health | grep -q "401\|200" && \
		echo "$(GREEN)✓ OpenSearch is reachable$(NC)" || \
		echo "$(RED)✗ OpenSearch is not reachable$(NC)"; \
	else \
		echo "$(YELLOW)OpenSearch not deployed yet$(NC)"; \
	fi

.PHONY: test-notebook
test-notebook: ## Test notebook session status
	@echo "$(BLUE)Testing notebook session...$(NC)"
	@SESSION_ID=$$($(TERRAFORM) output -raw notebook_session_id 2>/dev/null); \
	if [ -n "$$SESSION_ID" ]; then \
		STATE=$$($(OCI) data-science notebook-session get --notebook-session-id $$SESSION_ID --query 'data."lifecycle-state"' --raw-output 2>/dev/null); \
		if [ "$$STATE" = "ACTIVE" ]; then \
			echo "$(GREEN)✓ Notebook session is active$(NC)"; \
		else \
			echo "$(YELLOW)Notebook session state: $$STATE$(NC)"; \
		fi; \
	else \
		echo "$(YELLOW)Notebook not deployed yet$(NC)"; \
	fi

.PHONY: test-storage
test-storage: ## Test object storage bucket
	@echo "$(BLUE)Testing object storage...$(NC)"
	@BUCKET=$$($(TERRAFORM) output -raw bucket_name 2>/dev/null); \
	if [ -n "$$BUCKET" ]; then \
		$(OCI) os object list --bucket-name $$BUCKET --limit 1 > /dev/null 2>&1 && \
		echo "$(GREEN)✓ Object storage bucket is accessible$(NC)" || \
		echo "$(RED)✗ Object storage bucket is not accessible$(NC)"; \
	else \
		echo "$(YELLOW)Object storage not deployed yet$(NC)"; \
	fi

# ============================================================================
# Resource Management
# ============================================================================

.PHONY: list
list: ## List all resources in the state
	@echo "$(BLUE)Resources in Terraform state:$(NC)"
	@$(TERRAFORM) state list

.PHONY: show-resource
show-resource: ## Show specific resource (use RESOURCE=<name>)
	@if [ -z "$(RESOURCE)" ]; then \
		echo "$(YELLOW)Usage: make show-resource RESOURCE=<resource-name>$(NC)"; \
		echo "Example: make show-resource RESOURCE=oci_core_vcn.main"; \
	else \
		$(TERRAFORM) state show $(RESOURCE); \
	fi

.PHONY: import
import: ## Import existing resource (use RESOURCE= and ID=)
	@if [ -z "$(RESOURCE)" ] || [ -z "$(ID)" ]; then \
		echo "$(YELLOW)Usage: make import RESOURCE=<resource-type.name> ID=<resource-id>$(NC)"; \
		echo "Example: make import RESOURCE=oci_core_vcn.main ID=ocid1.vcn.oc1..."; \
	else \
		$(TERRAFORM) import $(RESOURCE) $(ID); \
	fi

# ============================================================================
# Utilities
# ============================================================================

.PHONY: format
format: ## Format Terraform files
	@echo "$(BLUE)Formatting Terraform files...$(NC)"
	@$(TERRAFORM) fmt -recursive
	@echo "$(GREEN)✓ Files formatted$(NC)"

.PHONY: clean
clean: ## Clean temporary files
	@echo "$(BLUE)Cleaning temporary files...$(NC)"
	@rm -rf .terraform.lock.hcl tfplan terraform.tfstate.backup
	@echo "$(GREEN)✓ Temporary files cleaned$(NC)"

.PHONY: backup
backup: ## Backup Terraform state
	@echo "$(BLUE)Backing up Terraform state...$(NC)"
	@cp terraform.tfstate terraform.tfstate.backup.$$(date +%Y%m%d_%H%M%S) 2>/dev/null || echo "No state file to backup"
	@echo "$(GREEN)✓ State backed up$(NC)"

.PHONY: console
console: ## Open Terraform console
	@$(TERRAFORM) console

.PHONY: graph
graph: ## Generate resource dependency graph
	@echo "$(BLUE)Generating dependency graph...$(NC)"
	@$(TERRAFORM) graph | dot -Tpng > infrastructure-graph.png
	@echo "$(GREEN)✓ Graph saved to infrastructure-graph.png$(NC)"

# ============================================================================
# Documentation
# ============================================================================

.PHONY: docs
docs: ## Generate documentation
	@echo "$(BLUE)Generating documentation...$(NC)"
	@$(TERRAFORM) output -json > outputs.json
	@echo "$(GREEN)✓ Documentation generated$(NC)"

.PHONY: checklist
checklist: ## Show deployment checklist
	@echo "$(BLUE)============================================================================$(NC)"
	@echo "$(BLUE)                    Deployment Checklist$(NC)"
	@echo "$(BLUE)============================================================================$(NC)"
	@echo ""
	@echo "Pre-deployment:"
	@echo "  [ ] OCI account with sufficient credits"
	@echo "  [ ] Compartment OCID obtained"
	@echo "  [ ] API key generated and configured"
	@echo "  [ ] terraform.tfvars configured"
	@echo "  [ ] Region set to us-chicago-1 (for GenAI)"
	@echo ""
	@echo "Deployment:"
	@echo "  [ ] Run: make setup"
	@echo "  [ ] Run: make plan"
	@echo "  [ ] Review plan output"
	@echo "  [ ] Run: make deploy"
	@echo ""
	@echo "Post-deployment:"
	@echo "  [ ] Access notebook session"
	@echo "  [ ] Test OpenSearch connection"
	@echo "  [ ] Upload documents to bucket"
	@echo "  [ ] Configure GenAI agent"
	@echo ""
	@echo "$(BLUE)============================================================================$(NC)"

# ============================================================================
# Stack Operations (for Resource Manager)
# ============================================================================

.PHONY: create-stack
create-stack: ## Create Resource Manager stack ZIP
	@echo "$(BLUE)Creating Resource Manager stack...$(NC)"
	@zip -r ../oci-genai-stack.zip . \
		-x "*.terraform*" \
		-x "*.tfstate*" \
		-x "tfplan" \
		-x "*.backup*" \
		-x ".git/*"
	@echo "$(GREEN)✓ Stack created: ../oci-genai-stack.zip$(NC)"

.PHONY: validate-stack
validate-stack: create-stack ## Validate stack with Resource Manager
	@echo "$(BLUE)Validating stack with Resource Manager...$(NC)"
	@echo "$(YELLOW)Upload ../oci-genai-stack.zip to Resource Manager to validate$(NC)"

# ============================================================================
# Development Helpers
# ============================================================================

.PHONY: dev-minimal
dev-minimal: ## Deploy minimal development environment
	@echo "$(BLUE)Deploying minimal development environment...$(NC)"
	@$(TERRAFORM) apply -auto-approve \
		-var="opensearch_master_node_count=1" \
		-var="opensearch_data_node_count=1" \
		-var="notebook_ocpus=1" \
		-var="notebook_memory_gb=8"
	@echo "$(GREEN)✓ Minimal environment deployed$(NC)"

.PHONY: dev-scale-up
dev-scale-up: ## Scale up development environment
	@echo "$(BLUE)Scaling up environment...$(NC)"
	@$(TERRAFORM) apply -auto-approve \
		-var="opensearch_data_node_count=2" \
		-var="notebook_ocpus=2" \
		-var="notebook_memory_gb=16"
	@echo "$(GREEN)✓ Environment scaled up$(NC)"

.PHONY: dev-scale-down
dev-scale-down: ## Scale down development environment
	@echo "$(BLUE)Scaling down environment...$(NC)"
	@$(TERRAFORM) apply -auto-approve \
		-var="opensearch_data_node_count=1" \
		-var="notebook_ocpus=1" \
		-var="notebook_memory_gb=8"
	@echo "$(GREEN)✓ Environment scaled down$(NC)"

# Default target
.DEFAULT: help