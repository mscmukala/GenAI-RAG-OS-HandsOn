# Hands-on Lab Playbook  

## Lab Title  
**Developing a GenAI Agent using OCI RAG with OpenSearch as the Knowledge Base**  

### 1. Infrastructure Setup  
#### Pre-proivistion Infrastructure
Considering the amount of time take to create OCI services using Terraform, some of the larger services and permissions will be pre provisioned before workshop
   Following services are pre-provisioned: 
   - OCI OpensearchDB, used store Vector Emeddedings to perform symantic search
      ref: https://docs.oracle.com/en/learn/oci-opensearch/index.html#introduction
   - OCI Network, For simplicity creating one VCN with public and Private along with required gateways
      ref: https://docs.oracle.com/en/solutions/wls-on-prem-to-oci/use-wizard-create-vcn.html
   - OCI Policies, required access permission for services to access 
     ref: /data/policies

### 2. User provision and Access 
   How the user will access the environment:  
      - User works within the defined tenancy (Srinivas Tenancy will be used)
      - User will be provided access, couple hours before the demo.
      {Each of the participant to provide thier full name and email}
      - User will get email once user provisioned and provided appropriate access
      - User login account with provided credentials.

### 3. Create Compartment 
      oci iam compartment list --name "handson-root" --all
----
      oci iam compartment create \
	--compartment-id <handson-root-ocid> \
	--name <sub-compartment-name> \
	--description "<description of sub-compartment>"

### 4. Create a Notebook Session  
   Login to OCI console, perform following 
   Step 1. "Under Analytics & AI"-->
                  Machine learning --> 
                     Data Science 
   Step 2. When creating the session, use following 
      - Compartment - Choose newly created compartment
      - Name: <name of your choice>
      - Compute shape: <shape of your choice> or leave default
      - Choose "Custom networking"
            -  Compartment: "handson-root" 
            -  VCN: "handson-vcn"
            -  Subnet: "private subnet-handson-vcn"
      -  Rest leave all default 
      - Udner Runtime configuration section
         - Add Git settings
               Click +Add get settings 
                  Git repo url: "https://github.com/mscmukala/GenAI-RAG-OS-HandsOn.git"
   Step 3: Click "Create"

Be patient Notebook creation take atleast 6-7 Mins

### 5. Execution  

Follow these steps to run the hands-on portion of the lab:  

1. In the notebook session, Under Luncher find 
      Open 
   
      1.a 
   Open the **Notebook session** 
2. Find the git repo added during Notebook session    creation.
3. Navigate to data-process-execution.ipynb file.  
4. Execute the notebook cells in sequence, following the instructions within.  

### 6. GenAI Agent creation  

 Login to OCI console, perform following 
   Step 1. "Under Analytics & AI"-->
               Click on "Generative AI Agents"
   Step 2. on Left select "Overview"
      Center of page notice, 
         "Get Started: Create your first agent" --> Click "Create Agent"
      Step1: Basic Information
            - Name: <of your choice>
            - Compartment - Choose newly created compartment
            leave rest value defaults
          Click "Next"
      Step 2: Add Tool ( Tools )
          Click Add tool 
            - Make sure RAG is selected 
            - under RAG configuration 
                  Enter Name: <of your choice>
                  Decription: "use knowledge to provide advanced medical reasoning. researches solutions to provided questions which are verifiable medical problems. Those responses are validated through a medical verifier."
      - Compute shape: <shape of your choice> or leave default
      - Choose "Custom networking"
            -  Compartment: "handson-root" 
            -  VCN: "handson-vcn"
            -  Subnet: "private subnet-handson-vcn"
      -  Rest leave all default 
   Step 3: Click "Create"

### 7. Perform Conversational Chat 
   Back to Agents listing screen
      - Find the agent create above
      - Click "Launch Chat"
      - Enter the diag query 
         ex: "Given a patient with sudden neurological symptoms after long-distance travel and evidence of leg swelling, what cardiac abnormality could explain these findings?"

### Summary  

By completing this lab, you will have:  
- Under the OCI AI services required to build solution around medical diag helper for medical professionals.
- Set up and executed a **Jupyter Notebook** to interact with the GenAI Agent.  
- Performed **semantic search** using OpenSearch as a knowledge base.  
