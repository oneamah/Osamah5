# Terraform EKS Platform

This repository provisions an AWS EKS platform with Terraform using reusable modules.

It creates:
- VPC networking (public/private subnets, NAT gateway)
- Optional bastion host with optional SSM access
- IAM roles and optional cluster admin IAM user
- EKS control plane and managed node group
- IRSA roles (service account IAM roles)
- Security groups for cluster/bastion communication
- Helm-managed add-ons (CoreDNS, ingress-nginx, Argo CD, kube-prometheus-stack, ExternalDNS)
- Optional Route53 records and HTTPS integration for ingress endpoints

## Repository Layout

```text
.
|-- backend.tf
|-- main.tf
|-- modules.tf
|-- outputs.tf
|-- terraform.tfvars
|-- variables.tf
`-- modules/
    |-- eks/
    |-- helm/
    |-- iam/
    |-- networking/
    |-- service-account/
    `-- sg/
```

## Prerequisites

- Terraform `~> 1.14.0`
- AWS credentials configured for the target account
- AWS permissions to manage VPC, EKS, IAM, EC2, Route53, and related resources
- S3 bucket for remote state backend (configured in `backend.tf`)

Providers used:
- `hashicorp/aws ~> 6.34.0`
- `hashicorp/helm ~> 3.1.1`
- `hashicorp/kubernetes ~> 2.37.0`
- `hashicorp/time ~> 0.12.0`
- `hashicorp/tls ~> 4.0.0`
- `hashicorp/random ~> 3.8.1`

## Remote State Backend

This project uses an S3 backend in `backend.tf`:

- Bucket: `marmil-project-terraform-state`
- Key: `marmil-project-terraform.tfstate`
- Region: `us-east-1`
- Locking: `use_lockfile = true`

Make sure the bucket exists and your IAM identity has read/write access before running `terraform init`.

## Quick Start

1. Initialize Terraform:

```bash
terraform init
```

2. Review changes:

```bash
terraform plan -var-file="terraform.tfvars"
```

3. Apply infrastructure:

```bash
terraform apply -var-file="terraform.tfvars"
```

4. (Optional) Destroy infrastructure:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Main Configuration Inputs

The root `terraform.tfvars` currently configures:
- Region: `us-west-2`
- Cluster name: `eks-cluster`
- Kubernetes version: `1.34`
- Node group: `t3.small` (`min=2`, `desired=3`, `max=3`)
- Argo CD host: `argocd.marmil.co`
- Grafana host: `grafana.marmil.co`
- HTTPS enabled: `enable_https = true`
- ExternalDNS enabled with domain filter `marmil.co`

Important variables are defined in `variables.tf`. Sensitive or environment-specific values should be set in `terraform.tfvars` (or via CI/CD secrets/variable injection).

## Outputs

Key outputs from `outputs.tf` include:
- IAM role/user details for EKS and service accounts
- Networking and bastion details (NAT IDs, bastion IP/ID)
- Argo CD and Grafana ingress URLs
- Optional Route53 FQDN outputs
- ExternalDNS Helm release name

To view outputs after apply:

```bash
terraform output
```

## Notes

- `modules.tf` references a module named `service-account` (with a hyphen). This is valid Terraform syntax.
- Route53 and ExternalDNS settings depend on a valid hosted zone ID and appropriate IAM permissions.
- If `create_route53_records = false`, DNS records for Argo CD/Grafana are not auto-created by the Helm module.
