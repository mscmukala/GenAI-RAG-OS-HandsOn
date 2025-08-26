
# OCI CLI Commands: Create Sub-Compartment under 'handson-root'

# 1. Get the OCID of the parent compartment (handson-root)
oci iam compartment list --name "handson-root" --all

# 2. Create a sub-compartment under 'handson-root'
oci iam compartment create \
	--compartment-id <handson-root-ocid> \
	--name <sub-compartment-name> \
	--description "<description of sub-compartment>"

# Example:
# oci iam compartment create \
#   --compartment-id ocid1.compartment.oc1..aaaaaaaaxxxxxxxx \
#   --name my-sub-compartment \
#   --description "Sub-compartment for GenAI project"



# ---
# Cleanup: Delete OCI Resources

## 1. Delete OCI Data Science Notebook Projects and Sessions

# List all notebook projects in a compartment
oci data-science project list --compartment-id <compartment-ocid>

# Delete a notebook project
oci data-science project delete --project-id <project-ocid>

# List all notebook sessions in a compartment (optionally filter by project)
oci data-science notebook-session list --compartment-id <compartment-ocid>
# or
oci data-science notebook-session list --project-id <project-ocid>

# Delete a notebook session
oci data-science notebook-session delete --notebook-session-id <notebook-session-ocid>

## 2. Delete OCI GenAI Agent, RAG Tool, and Knowledge Base

# List all GenAI agents in a compartment
oci generative-ai agent list --compartment-id <compartment-ocid>

# Delete a GenAI agent
oci generative-ai agent delete --agent-id <agent-ocid>

# List all RAG tools in a compartment or for an agent
oci generative-ai rag-tool list --compartment-id <compartment-ocid>
# or
oci generative-ai rag-tool list --agent-id <agent-ocid>

# Delete a RAG tool
oci generative-ai rag-tool delete --rag-tool-id <rag-tool-ocid>

# List all knowledge bases in a compartment
oci generative-ai knowledge-base list --compartment-id <compartment-ocid>

# Delete a knowledge base
oci generative-ai knowledge-base delete --knowledge-base-id <knowledge-base-ocid>

## 3. Delete Sub-Compartment

# Get the OCID of the sub-compartment you want to delete
oci iam compartment list --name <sub-compartment-name> --all

# Delete the sub-compartment (moves to DELETING state)
oci iam compartment delete --compartment-id <sub-compartment-ocid>

# (Optional) Verify deletion status
oci iam compartment get --compartment-id <sub-compartment-ocid>

# Note: A compartment must be empty (no resources) before it can be deleted.

# Note: Replace <compartment-ocid>, <project-ocid>, <notebook-session-ocid>, <agent-ocid>, <rag-tool-ocid>, <knowledge-base-ocid>, and <sub-compartment-ocid> with actual values.
 