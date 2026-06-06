# AWS Multi-Environment Infrastructure Platform

A production-style Terraform project that provisions and manages isolated AWS environments using a single codebase, custom Terraform modules, and Terraform Workspaces.

---

## Project Overview

Managing infrastructure across Development, Staging, and Production environments is a common challenge in modern DevOps practices.

This project demonstrates how to:

* Use a single Terraform codebase for multiple environments
* Implement reusable Terraform modules
* Manage environment isolation using Terraform Workspaces
* Deploy AWS infrastructure consistently and efficiently
* Follow Infrastructure as Code (IaC) best practices

---

## Architecture

Each environment provisions:

* VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association
* Security Group
* EC2 Instance

Infrastructure is deployed separately for:

* Development (dev)
* Staging (staging)
* Production (prod)

---

## Project Structure

```text
aws-terraform-multi-env-infra/
│
├── providers.tf
├── variables.tf
├── locals.tf
├── main.tf
├── outputs.tf
│
├── dev.tfvars
├── staging.tfvars
├── prod.tfvars
│
├── .gitignore
│
└── modules/
    │
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security-group/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── ec2-instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Terraform Workspaces

This project uses Terraform Workspaces to manage multiple environments.

### Create Workspaces

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### List Workspaces

```bash
terraform workspace list
```

### Switch Workspace

```bash
terraform workspace select dev
```

### Show Current Workspace

```bash
terraform workspace show
```

---

## Environment Configuration

### Development

```hcl
vpc_cidr      = "10.0.0.0/16"
subnet_cidr   = "10.0.1.0/24"
instance_type = "t2.micro"
ingress_ports = [22, 80]
```

### Staging

```hcl
vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"
instance_type = "t2.small"
ingress_ports = [22, 80, 443]
```

### Production

```hcl
vpc_cidr      = "10.2.0.0/16"
subnet_cidr   = "10.2.1.0/24"
instance_type = "t3.small"
ingress_ports = [80, 443]
```

---

## Prerequisites

Before starting, ensure you have:

* AWS Account
* AWS CLI configured
* Terraform >= 1.5
* IAM permissions to create AWS resources

Verify AWS credentials:

```bash
aws sts get-caller-identity
```

Verify Terraform version:

```bash
terraform version
```

---

# Deployment Workflow

## 1. Clone Repository

```bash
git clone https://github.com/<your-github-username>/aws-terraform-multi-env-infra.git

cd aws-terraform-multi-env-infra
```

---

## 2. Initialize Terraform

Downloads required providers and initializes the working directory.

```bash
terraform init
```

---

## 3. Format Terraform Code

Ensures all Terraform files follow standard formatting.

```bash
terraform fmt -recursive
```

---

## 4. Validate Configuration

Checks Terraform syntax and configuration consistency.

```bash
terraform validate
```

Expected output:

```text
Success! The configuration is valid.
```

---

## 5. Create Workspaces

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

---

## 6. Review Execution Plan

### Development

```bash
terraform workspace select dev

terraform plan \
-var-file=dev.tfvars
```

### Staging

```bash
terraform workspace select staging

terraform plan \
-var-file=staging.tfvars
```

### Production

```bash
terraform workspace select prod

terraform plan \
-var-file=prod.tfvars
```

---

## 7. Deploy Infrastructure

### Development

```bash
terraform workspace select dev

terraform apply \
-var-file=dev.tfvars
```

### Staging

```bash
terraform workspace select staging

terraform apply \
-var-file=staging.tfvars
```

### Production

```bash
terraform workspace select prod

terraform apply \
-var-file=prod.tfvars
```

---

## Recommended Terraform Workflow

Always execute commands in this order:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=<environment>.tfvars
terraform apply -var-file=<environment>.tfvars
```

This helps catch formatting issues, syntax errors, and configuration mistakes before infrastructure changes are applied.

---

## Verify Deployments

Check outputs:

```bash
terraform workspace select dev
terraform output

terraform workspace select staging
terraform output

terraform workspace select prod
terraform output
```

Verify in AWS Console:

* Three VPCs
* Three Public Subnets
* Three Security Groups
* Three EC2 Instances
* Separate CIDR blocks
* Correct resource tags

---

## Naming Convention

Resources follow:

```text
<project>-<environment>-<resource>
```

Examples:

```text
terraweek-dev-vpc
terraweek-dev-server

terraweek-staging-vpc
terraweek-staging-server

terraweek-prod-vpc
terraweek-prod-server
```

---

## Tagging Strategy

All resources should include:

```text
Project
Environment
ManagedBy
Workspace
```

Example:

```text
Project     = terraweek
Environment = dev
ManagedBy   = Terraform
Workspace   = dev
```

---

## Terraform Best Practices

### File Structure

Keep files separated by responsibility:

* providers.tf
* variables.tf
* locals.tf
* main.tf
* outputs.tf

### State Management

* Use remote backend (S3)
* Enable state locking
* Enable versioning
* Encrypt state at rest

### Variables

* Never hardcode values
* Use tfvars files
* Add validation blocks

### Modules

* One concern per module
* Define inputs and outputs
* Reuse modules
* Version modules

### Workspaces

* Use workspaces for environment isolation
* Reference `terraform.workspace`

### Security

* Ignore tfstate files
* Ignore tfvars files
* Restrict backend access
* Encrypt backend storage

### Commands

Always run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Before:

```bash
terraform apply
```

### Tagging

Tag every resource consistently.

### Naming

Use:

```text
<project>-<environment>-<resource>
```

### Cleanup

Destroy unused environments to avoid unnecessary AWS costs.

---

## Cleanup

### Destroy Production

```bash
terraform workspace select prod

terraform destroy \
-var-file=prod.tfvars
```

### Destroy Staging

```bash
terraform workspace select staging

terraform destroy \
-var-file=staging.tfvars
```

### Destroy Development

```bash
terraform workspace select dev

terraform destroy \
-var-file=dev.tfvars
```

---

## Delete Workspaces

```bash
terraform workspace select default

terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```

---

## Learning Outcomes

By completing this project, you gain practical experience with:

* Infrastructure as Code (IaC)
* Terraform Workspaces
* AWS Infrastructure Provisioning
* Custom Terraform Modules
* State Management
* Environment Isolation
* Production-Ready Terraform Practices

---

## TerraWeek Learning Journey

| Day | Concepts                                                                 |
| --- | ------------------------------------------------------------------------ |
| 61  | IaC, HCL, Init, Plan, Apply, Destroy, State Basics                       |
| 62  | Providers, Resources, Dependencies, Lifecycle                            |
| 63  | Variables, Outputs, Data Sources, Locals, Functions                      |
| 64  | Remote Backend, State Locking, Import, Drift Detection                   |
| 65  | Custom Modules, Registry Modules, Versioning                             |
| 66  | EKS Provisioning with Terraform Modules                                  |
| 67  | Terraform Workspaces, Multi-Environment Infrastructure, Capstone Project |

---

## Author

**Kiran Hingankar**
