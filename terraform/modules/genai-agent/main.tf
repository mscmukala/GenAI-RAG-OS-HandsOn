# GenAI Agent Module for OCI GenAI Integration Lab
# Note: As of the creation of this module, GenAI Agent resources may need to be 
# created manually through the OCI Console. This module provides configuration
# outputs and documentation for the manual setup process.

# Local variables for GenAI configuration
locals {
  genai_endpoint = "https://inference.generativeai.us-chicago-1.oci.oraclecloud.com"
  agent_endpoint = "https://agent.generativeai.us-chicago-1.oci.oraclecloud.com"
}

# Null resource to document the GenAI Agent setup process
resource "null_resource" "genai_agent_setup" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "=========================================="
      echo "GenAI Agent Setup Instructions"
      echo "=========================================="
      echo ""
      echo "Please complete the following steps in the OCI Console:"
      echo ""
      echo "1. Navigate to Analytics & AI > AI Services > Generative AI Agents"
      echo "2. Create a new Agent with the following configuration:"
      echo "   - Name: ${var.agent_display_name}"
      echo "   - Compartment: ${var.compartment_id}"
      echo "   - Description: RAG agent for document Q&A"
      echo ""
      echo "3. Create a Knowledge Base:"
      echo "   - Name: ${var.knowledge_base_name}"
      echo "   - Data Source Type: Object Storage"
      echo "   - Bucket: ${var.object_storage_bucket}"
      echo "   - Prefix: documents/"
      echo ""
      echo "4. Configure RAG Tool:"
      echo "   - Type: OpenSearch"
      echo "   - Endpoint: ${var.opensearch_endpoint}"
      echo "   - Index: ${var.opensearch_index_name}"
      echo ""
      echo "5. Configure Agent Settings:"
      echo "   - Model: cohere.command-r-plus"
      echo "   - Temperature: 0.7"
      echo "   - Max Tokens: 2048"
      echo ""
      echo "=========================================="
    EOT
  }
}

# Create a configuration file for the agent
resource "local_file" "agent_config" {
  filename = "${path.module}/agent_config.json"
  content = jsonencode({
    agent_name           = var.agent_display_name
    knowledge_base_name  = var.knowledge_base_name
    compartment_id       = var.compartment_id
    opensearch_endpoint  = var.opensearch_endpoint
    opensearch_index     = var.opensearch_index_name
    object_storage = {
      namespace = var.object_storage_namespace
      bucket    = var.object_storage_bucket
      prefix    = "documents/"
    }
    model_config = {
      model_id     = "cohere.command-r-plus"
      temperature  = 0.7
      max_tokens   = 2048
      top_p        = 0.9
    }
    embedding_config = {
      model_id = "cohere.embed-english-v3.0"
    }
    rag_config = {
      chunk_size       = 1000
      chunk_overlap    = 200
      top_k            = 5
      similarity_threshold = 0.7
    }
    endpoints = {
      genai_inference = local.genai_endpoint
      genai_agent     = local.agent_endpoint
    }
  })
}

# Create sample prompts for testing
resource "local_file" "sample_prompts" {
  filename = "${path.module}/sample_prompts.txt"
  content = <<-EOT
    # Sample Prompts for Testing the GenAI Agent
    
    ## General Questions
    1. "What documents are available in the knowledge base?"
    2. "Can you summarize the main topics covered in the documents?"
    3. "What is the purpose of this system?"
    
    ## Specific Queries
    1. "How does OpenSearch integrate with OCI GenAI?"
    2. "What are the benefits of using RAG?"
    3. "Explain the document chunking process"
    4. "What embedding models are available?"
    
    ## Technical Questions
    1. "How do I configure the OpenSearch index for vector search?"
    2. "What are the recommended chunk sizes for document processing?"
    3. "How can I optimize the similarity search performance?"
    
    ## Use Case Questions
    1. "What are some use cases for this RAG implementation?"
    2. "How can this help with customer support?"
    3. "Can this system handle multiple languages?"
    
    ## System Questions
    1. "What is the maximum document size supported?"
    2. "How many documents can be processed simultaneously?"
    3. "What file formats are supported?"
  EOT
}

# Create Python script for agent interaction
resource "local_file" "agent_client" {
  filename = "${path.module}/agent_client.py"
  content = <<-EOT
    #!/usr/bin/env python3
    """
    OCI GenAI Agent Client
    This script demonstrates how to interact with the GenAI Agent
    """
    
    import oci
    import json
    from typing import Dict, Any
    
    class GenAIAgentClient:
        def __init__(self, config_file: str = "agent_config.json"):
            with open(config_file, 'r') as f:
                self.config = json.load(f)
            
            # Initialize OCI client
            self.oci_config = oci.config.from_file()
            
        def create_session(self) -> str:
            """Create a new chat session"""
            # Implementation would use actual GenAI Agent API
            return "session_" + str(hash(str(self.config)))
        
        def send_message(self, session_id: str, message: str) -> Dict[str, Any]:
            """Send a message to the agent"""
            # Implementation would use actual GenAI Agent API
            return {
                "session_id": session_id,
                "message": message,
                "response": "This is a placeholder response",
                "sources": [],
                "confidence": 0.0
            }
        
        def list_documents(self) -> list:
            """List documents in the knowledge base"""
            # Implementation would query Object Storage
            return ["document1.pdf", "document2.txt", "document3.md"]
    
    def main():
        client = GenAIAgentClient()
        session_id = client.create_session()
        
        print("GenAI Agent Client")
        print("=" * 50)
        print(f"Session ID: {session_id}")
        print("Type 'quit' to exit")
        print()
        
        while True:
            message = input("You: ")
            if message.lower() == 'quit':
                break
            
            response = client.send_message(session_id, message)
            print(f"Agent: {response['response']}")
            print()
    
    if __name__ == "__main__":
        main()
  EOT
}

# Outputs
output "agent_id" {
  description = "GenAI Agent ID (placeholder - create manually)"
  value       = "genai-agent-${substr(md5(var.agent_display_name), 0, 8)}"
}

output "agent_endpoint" {
  description = "GenAI Agent endpoint"
  value       = local.agent_endpoint
}

output "knowledge_base_id" {
  description = "Knowledge Base ID (placeholder - create manually)"
  value       = "kb-${substr(md5(var.knowledge_base_name), 0, 8)}"
}

output "genai_inference_endpoint" {
  description = "GenAI Inference endpoint"
  value       = local.genai_endpoint
}

output "configuration_file" {
  description = "Path to agent configuration file"
  value       = local_file.agent_config.filename
}

output "setup_instructions" {
  description = "Instructions for manual GenAI Agent setup"
  value = <<-EOT
    Please complete the GenAI Agent setup manually in the OCI Console.
    Configuration has been saved to: ${local_file.agent_config.filename}
    Sample prompts available at: ${local_file.sample_prompts.filename}
    Python client script at: ${local_file.agent_client.filename}
  EOT
}