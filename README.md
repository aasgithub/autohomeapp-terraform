# ☁️ AutoHomeApp (Infrastructure as Code)

This repository contains the **Infrastructure as Code (IaC)** configuration for **AutoHomeApp**, automating the provisioning and teardown of cloud resources on **Amazon Web Services (AWS)** using **Terraform** and shell provisioning scripts.

---

## 🛠️ Tech Stack

* **Cloud Provider:** Amazon Web Services (AWS)
* **Infrastructure as Code (IaC):** Terraform
* **Provisioning & Automation:** Bash / Shell Scripts (`userdata.sh`)

---

## 📁 Project Structure

```text
autohomeapp-infra/
├── terraform/
│   ├── instance.tf             # AWS EC2 instance and cloud resource definitions
│   ├── userdata.sh             # Bootstrap script executed on instance startup
│   └── remove_userdata.sh      # Cleanup / teardown helper script
├── .gitignore                  # Git ignore rules
└── README.md                   # Project documentation
```

---

## 📋 Prerequisites

Before running the Terraform scripts, make sure you have the following installed and configured:

* [Terraform](https://hashicorp.com) (v1.0+)
* [AWS CLI](https://amazon.com) installed and configured (`aws configure`) with an IAM user that has permissions to provision EC2 and related resources
* An existing **AWS Key Pair** (if SSH access is configured in `instance.tf`)

---

## 🚀 Getting Started (Provisioning Infrastructure)

### 1. Clone the repository
```bash
git clone git@github.com:aasgithub/autohomeapp-terraform.git
cd autohomeapp-infra/terraform
```

### 2. Initialize Terraform
Download the required AWS provider plugins:
```bash
terraform init
```

### 3. Review the execution plan
Preview the AWS resources that will be created:
```bash
terraform plan
```

### 4. Apply the configuration
Provision the infrastructure on AWS:
```bash
terraform apply
```
*(Type `yes` when prompted to confirm).*

---

## 🧹 Destroying Infrastructure

To avoid unnecessary AWS billing when the environment is no longer needed, tear down all provisioned resources:

```bash
terraform destroy
```

---
