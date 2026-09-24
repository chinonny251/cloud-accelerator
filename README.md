# Day 1: Local Cloud Workstation Setup

I created a project folder on my Windows Desktop and opened it inside VS Code. Because I am using Windows Subsystem for Linux (WSL), Linux can see and run files directly from this Windows folder.

### Why this setup works:
It gives me the best of both worlds. I can easily edit my code using the visual VS Code windows interface, but when I run the code, it executes inside a real Linux terminal. This keeps my files safe on Windows while making sure my scripts run in a real Linux environment.

### My Bootstrap Script (`wsl_bootstrap.sh`):
```bash
#!/bin/bash
echo "=== Bootstrapping AWS CLI ==="
echo "Workspace ready on Windows Host"
```

### Terminal Output:
```text
root@COSIGWE1024:/mnt/c/CLOUD-ACCELERATOR# ./wsl_bootstrap.sh
=== Bootstrapping AWS CLI ===
Workspace ready on Windows Host
```
## Day 4: Automated Environment Validation Scripting

### AWS Session Verification Script (`verify_aws_session.sh`):
```bash
#!/usr/bin/env bash

if /snap/bin/aws sts get-caller-identity --output json; then
	printf '%s\n' '[SUCCESS] AWS Session is active and secure.'
else
	printf '%s\n' '[ERROR] AWS Token expired or missing. Please run: /snap/bin/aws configure sso --use-device-code'
fi
```

### Why Exit Status Checks Matter:
Every command returns an exit status: `0` means success, while a non-zero value means the command failed. Bash exposes the most recent command's status through `$?`, which allows scripts to make decisions based on what actually happened instead of assuming a command worked.

## Day 5: Cross-Cloud Service Connections
linked Azure DevOps to AWS using a secure Service Connection, creating the dedicated communication bridge necessary for automated pipelines to deploy cloud architecture.

### Why this setup works:
This connection sets up a secure, authenticated bridge between our two cloud providers. It means Azure Pipelines can dynamically talk to my AWS account and deploy infrastructure automatically, eliminating the need to save unencrypted passwords or keys inside our repository code.
## Week 2, Day 1: Terraform Local Architecture Initialization
Initialized the AWS Terraform provider locally without hardcoding keys

## Week 2, Day 2: Provisioning S3 via IaC

I used Terraform to provision a private AWS S3 bucket using a declarative configuration file (`s3.tf`).

### Why this setup works:
By writing infrastructure as code, I can track, deploy, and delete cloud resources predictably using automated terminal commands instead of clicking through the AWS console interface.

## Week 3, Day 3: Decoupled Variable Overrides
I used a .tfvars file to change parameters dynamically without editing master resource code.

## Week 4, Day 1: Deplaying VPC Core via IaC
deployed a custom 10.0.0.0/16 private network shell using Terraform
## Week 4, Day 2: Public Subnet and Gateway Integration
Attaching an internet gateway turns a generic subnet into a public subnet. A subnet becomes public when it's associated route table contains a rule mapping all outbound traffic(0.0.0.0/0) straight to an active Internet Gateway.
## Week 4, Day 3: Private Subnet Isolation
I set map_public_ip_on_launch to false and associate it with a standalone route table that contains no active rules pointing to an Internet gateway
## Week 4, Day 4: Multi-AZ Fault Tolerance
I provision duplicate public and private subnet tiers distributed evenly across mulitple availability zones, ensuring the infrastructure remains operational if a single zones experiences outage.
## Week 4, Day 5: Stateful Firewalls via Security Groups
Security Groups are stateful firwalls at the instance level and they only allow permit rules. NACKLs are stateless firewalls that operate at the subnet level and can explicitly allow or deny traffic.
## Week 5, Day 1: Provisioning Core Compute Workloads (EC2)
### Architecture Overview
Today, I advanced my custom network architecture by provisioning active compute layers inside my public and private subnets. The architecture isolates backend resources while maintaining secure external access paths.
### Key Implementations & Concepts
* **Infrastructure as Code (IaC):** Automated the deployment of EC2 virtual instances using Terraform, integrating `tls_private_key` and `local_file` providers to generate secure SSH key pairs on the fly.
* **Stateful Firewalls (Security Groups):** Configured distinct firewalls mapping explicit ingress controls. The private instance uses security group chaining to completely isolate it from the wider internet.
* **SSH Agent Forwarding:** Practised multi-hop cloud networking by forwarding local cryptographic keys through the bastion host to access the hidden backend workload, ensuring private keys are never uploaded to the cloud.
## Week 5, Day 2: Automated Workload Bootstrapping with EC2 User Data

### Architecture Progress
Successfully transitioned infrastructure from static components to automated, dynamic setups using EC2 User Data scripts. Verified network-hop paths and investigated the behavioral limitations of bootstrapping instances inside isolated private subnets.

### Implementations & Automations
* **Public Subnet Configuration:** Provisioned an automated Nginx server (`web_bootstrap.sh`) on boot to serve a custom HTML portfolio page, explicitly validating external visibility configurations over HTTP (Port 80).
* **Private Subnet Configuration:** Drafted a secure background runtime hook (`app_bootstrap.sh`) to pre-install Docker container runtimes on an isolated backend node.
* **Network Observation:** Verified that instances in an isolated private subnet fail to pull external repository packages (e.g., Docker) on boot due to the absence of an outbound internet route. This establishes the operational prerequisite for a NAT Gateway.
