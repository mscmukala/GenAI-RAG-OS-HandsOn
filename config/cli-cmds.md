
# =============================
# OCI CLI COMMANDS CHEATSHEET
# =============================


## 1. Create Sub-Compartment under 'handson-root'

### Get the OCID of the parent compartment (handson-root)
```sh
oci iam compartment list --name "handson-root" --all
```

### Create a sub-compartment under 'handson-root'
```sh
oci iam compartment create \
	--compartment-id <handson-root-ocid> \
	--name <sub-compartment-name> \
	--description "<description of sub-compartment>"
# Example:
# oci iam compartment create \
#   --compartment-id ocid1.compartment.oc1..aaaaaaaaxxxxxxxx \
#   --name my-sub-compartment \
#   --description "Sub-compartment for GenAI project"
```

---

## 2. Create OCI Data Science Notebook Project and Session

### Create a notebook project in a compartment
```sh
oci data-science project create \
	--compartment-id <compartment-ocid> \
	--display-name <project-name> \
	--description "<project-description>"
# Example:
# oci data-science project create \
#   --compartment-id ocid1.compartment.oc1..aaaaaaaaxxxxxxxx \
#   --display-name "genai-lab-project" \
#   --description "Project for GenAI medical reasoning lab"
```

### Create a notebook session in a project
```sh
oci data-science notebook-session create \
	--compartment-id <compartment-ocid> \
	--project-id <project-ocid> \
	--display-name <session-name> \
	--notebook-session-configuration-details-shape <shape> \
	--notebook-session-configuration-details-block-storage-size-in-gbs <size-in-gb> \
	--subnet-id <subnet-ocid>
# Example:
# oci data-science notebook-session create \
#   --compartment-id ocid1.compartment.oc1..aaaaaaaaxxxxxxxx \
#   --project-id ocid1.datascienceproject.oc1..aaaaaaaayyyyyyyy \
#   --display-name "genai-lab-session" \
#   --notebook-session-configuration-details-shape VM.Standard2.1 \
#   --notebook-session-configuration-details-block-storage-size-in-gbs 50 \
#   --subnet-id ocid1.subnet.oc1..aaaaaaaazzzzzzzz
```

> Note: Replace placeholders (e.g., <compartment-ocid>) with actual values.

---

## 3. Create OCI GenAI Agent with RAG Tool and OpenSearch Knowledge Base

### Create a GenAI Agent
```sh
oci generative-ai agent create \
	--compartment-id <compartment-ocid> \
	--display-name <agent-name> \
	--description "<agent-description>"
# Example:
# oci generative-ai agent create \
#   --compartment-id ocid1.compartment.oc1..aaaaaaaaxxxxxxxx \
#   --display-name "genai-medical-agent" \
#   --description "GenAI agent for medical reasoning"
```

### Create a RAG Tool for the Agent (with OpenSearch as Knowledge Base)
```sh
oci generative-ai rag-tool create \
	--compartment-id <compartment-ocid> \
	--agent-id <agent-ocid> \
	--display-name <rag-tool-name> \
	--description "<rag-tool-description>" \
	--knowledge-base-type OPENSEARCH \
	--knowledge-base-configuration '{
		"opensearchEndpoint": "<opensearch-endpoint>",
		"opensearchIndex": "<opensearch-index>",
		"opensearchUsername": "<opensearch-username>",
		"opensearchPasswordSecretId": "<vault-secret-ocid>"
	}'
# Example:
# oci generative-ai rag-tool create \
#   --compartment-id ocid1.compartment.oc1..aaaaaaaaxxxxxxxx \
#   --agent-id ocid1.generativeaiagent.oc1..aaaaaaaayyyyyyyy \
#   --display-name "medical-rag-tool" \
#   --description "RAG tool for medical OpenSearch KB" \
#   --knowledge-base-type OPENSEARCH \
#   --knowledge-base-configuration '{
#     "opensearchEndpoint": "https://opensearch-instance.example.com",
#     "opensearchIndex": "medical-knowledge-index",
#     "opensearchUsername": "admin",
#     "opensearchPasswordSecretId": "ocid1.vaultsecret.oc1..zzzzzzzz"
#   }'
```

> Note: Pass the OCID of a pre-created/existing vault secret for OpenSearch password as <vault-secret-ocid>.
> Replace all placeholders with actual values.

---

---

# =============================
# Cleanup: Delete OCI Resources
# =============================



## 1. Delete OCI GenAI Agent, RAG Tool, and OpenSearch Knowledge Base

### List all knowledge bases in a compartment
```sh
oci generative-ai knowledge-base list --compartment-id <compartment-ocid>
```

### Delete the knowledge base
```sh
oci generative-ai knowledge-base delete --knowledge-base-id <knowledge-base-ocid>
```

### List all RAG tools for the agent
```sh
oci generative-ai rag-tool list --agent-id <agent-ocid>
```

### Delete the RAG tool
```sh
oci generative-ai rag-tool delete --rag-tool-id <rag-tool-ocid>
```

### List all GenAI agents in a compartment
```sh
oci generative-ai agent list --compartment-id <compartment-ocid>
```

### Delete the GenAI agent
```sh
oci generative-ai agent delete --agent-id <agent-ocid>
```

---

## 2. Delete OCI Data Science Notebook Projects and Sessions

### List all notebook projects in a compartment
```sh
oci data-science project list --compartment-id <compartment-ocid>
```

### Delete a notebook project
```sh
oci data-science project delete --project-id <project-ocid>
```

### List all notebook sessions in a compartment (optionally filter by project)
```sh
oci data-science notebook-session list --compartment-id <compartment-ocid>
# or
oci data-science notebook-session list --project-id <project-ocid>
```

### Delete a notebook session
```sh
oci data-science notebook-session delete --notebook-session-id <notebook-session-ocid>
```



## 3. Delete Sub-Compartment

### Get the OCID of the sub-compartment you want to delete
```sh
oci iam compartment list --name <sub-compartment-name> --all
```

### Delete the sub-compartment (moves to DELETING state)
```sh
oci iam compartment delete --compartment-id <sub-compartment-ocid>
```

### (Optional) Verify deletion status
```sh
oci iam compartment get --compartment-id <sub-compartment-ocid>
```

> Note: A compartment must be empty (no resources) before it can be deleted.
> 
> Replace <compartment-ocid>, <project-ocid>, <notebook-session-ocid>, <agent-ocid>, <rag-tool-ocid>, <knowledge-base-ocid>, and <sub-compartment-ocid> with actual values.
 
