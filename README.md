<div align="center">

  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=2,25,45&height=220&section=header&text=ENTERPRISE%20AZURE%20PAAS%20LANDING%20ZONE&fontSize=38&fontAlignY=38&animation=fadeIn&fontColor=ffffff&desc=Cloud-Native%20Serverless%20%7C%20App%20Services%20%7C%20Private%20Endpoints%20%7C%20APIM%20%7C%20Cosmos%20DB&descSize=16&descAlignY=62&descAlign=50" width="100%" alt="PaaS Landing Zone Banner" />

  <p align="center">
    <img src="https://img.shields.io/badge/Architecture-Cloud--Native_PaaS-0089D6?style=for-the-badge&logo=microsoftazure" />
    <img src="https://img.shields.io/badge/Compute-App_Services_%26_Functions-0078D4?style=for-the-badge&logo=azurefunctions" />
    <img src="https://img.shields.io/badge/Security-Zero_Public_PaaS_(Private_Link)-green?style=for-the-badge&logo=shield" />
    <img src="https://img.shields.io/badge/API-API_Management_(APIM)-orange?style=for-the-badge&logo=fastapi" />
    <img src="https://img.shields.io/badge/IaC-Terraform_Modular-7B42BC?style=for-the-badge&logo=terraform" />
  </p>

</div>

---

## 🏛️ Architecture Overview

This repository provides an **Enterprise Cloud-Native Platform-as-a-Service (PaaS) Landing Zone** designed according to Microsoft Cloud Adoption Framework (CAF) zero-trust architecture.

It eliminates public exposure by placing all PaaS services (Azure App Services, Serverless Functions, Azure SQL, Cosmos DB, and Key Vault) behind **Private Endpoints**, interconnected via **Regional VNet Integration** and fronted by **Azure API Management (APIM)**.

```mermaid
graph TD
    subgraph EdgeTier["🌍 Global Edge & Ingress"]
        AFD["Azure Front Door Premium / WAF"]
    end

    subgraph SpokePaaS["☁️ Cloud-Native PaaS Spoke VNet (172.16.32.0/20)"]
        subgraph IngressSubnet["APIM / Gateway Subnet"]
            APIM["Azure API Management (Internal Mode)\n(OAuth2 / OIDC Policies)"]
        end

        subgraph IntegrationSubnet["VNet Integration Subnet"]
            APPSVC["Azure App Service (Linux Web App)\n(Regional VNet Integrated)"]
            FUNCS["Azure Functions (Serverless Events)"]
        end

        subgraph PrivateLinkSubnet["Private Endpoint Subnet"]
            PE_SQL["Private Endpoint: Azure SQL"]
            PE_KV["Private Endpoint: Key Vault"]
            PE_COSMOS["Private Endpoint: Cosmos DB"]
        end
    end

    AFD ==> |"Private Link Origin"| APIM
    APIM --> APPSVC
    APIM --> FUNCS
    APPSVC ==> |"Zero Public Network"| PE_SQL
    APPSVC ==> |"Managed Identity"| PE_KV
    FUNCS ==> |"Event Streaming"| PE_COSMOS
```

---

## ⚡ Key Highlights

| Pillar | Capability & Production Design |
| :--- | :--- |
| **🔒 Zero Public Access** | Every single PaaS resource has `public_network_access_enabled = false`, isolated completely inside private subnets. |
| **🌐 Regional VNet Integration** | Dedicated delegated subnet allowing App Services and Functions to call internal databases and microservices securely. |
| **🔑 Passwordless Identity** | Managed Identities (System-Assigned & User-Assigned) eliminate all hardcoded database credentials and API secrets. |
| **🚦 Enterprise API Gateway** | Azure API Management (APIM) in Internal VNet mode enforcing rate limiting, JWT token validation, and API versioning. |
| **💾 Multi-Model Data Tier** | Azure SQL Database and Azure Cosmos DB with automated failover and customer-managed encryption keys. |
| **🔄 Automated CI/CD** | Full DevSecOps pipeline with Terraform linting, Checkov compliance audit, and automated validation. |

---

## 📁 Repository Structure

```text
Enterprise-Azure-PaaS-Landing-Zone/
├── .github/workflows/
│   └── devsecops-ci-cd.yml       # DevSecOps Pipeline: Lint, SAST, Infracost, Plan
├── terraform/
│   ├── modules/
│   │   ├── paas_network/         # Spoke VNet, Subnet Delegation, Private DNS
│   │   ├── paas_compute/         # App Service Plan, Linux Web App, Function App
│   │   └── paas_data/            # Azure SQL, Cosmos DB, Key Vault, Private Endpoints
│   └── environments/
│       └── prod/
│           ├── main.tf           # Root Orchestrator
│           ├── variables.tf
│           ├── terraform.tfvars
│           └── versions.tf
└── README.md
```

---

## 🚀 Quick Start & Deployment

### Prerequisites
* Terraform `>= 1.5.0`
* Azure CLI `>= 2.50.0`
* Active Azure Subscription

### Local Execution

```bash
cd terraform/environments/prod

# Initialize Terraform modules
terraform init

# Validate syntax
terraform validate

# Review plan
terraform plan

# Apply infrastructure
terraform apply -auto-approve
```

---

## 👤 Author
**Raghvendra Singh**  
Lead DevSecOps Architect & Enterprise Cloud Strategist  
GitHub: [@raghvendrasingh-devops](https://github.com/raghvendrasingh-devops)  
LinkedIn: [raghvendra-singh-devops](https://linkedin.com/in/raghvendra-singh-devops)
