# ☁️ Azure CloudLab — Secure Web Application

Hands-on Azure infrastructure project focused on deploying, securing and monitoring a Windows-based web application.

This project is part of my practical preparation for the **Microsoft Certified: Azure Administrator Associate (AZ-104)**.

---

# 🇺🇸 English

## 🎯 Project Objective

Build and manage a small web application environment in Microsoft Azure, applying practical concepts of cloud administration, networking, security, monitoring and cost management.

The project demonstrates the implementation of:

- Azure Virtual Machines
- Azure Virtual Network
- Network Security Groups (NSG)
- Windows Server 2025
- IIS Web Server
- Public and private IP addressing
- Azure Monitor
- OpenTelemetry metrics
- Managed Identity
- Resource tagging
- Cost-aware resource management[]

  ---

## 🏗️ Architecture

Internet
   │
   │ HTTP
   ▼
Public IP
   │
   ▼
Azure Virtual Network (10.10.0.0/16)
   │
   └── snet-app (10.10.2.0/24)
          │
          └── WEB-01
                 ├── Windows Server 2025
                 └── IIS
                         │
                         ▼
                    Azure Monitor

                    ---

## 🖥️ Virtual Machine

| Property | Configuration |
|---|---|
| Name | WEB-01 |
| Operating System | Windows Server 2025 Datacenter: Azure Edition |
| Size | Standard_DC1ds_v3 |
| vCPU | 1 |
| Memory | 8 GiB |
| Region | East US |
| Private IP | 10.10.2.4 |
| Web Server | IIS |
| Secure Boot | Enabled |
| vTPM | Enabled |
| Managed Identity | System-assigned |


---

## 🌐 Networking

### Virtual Network

**VNET-CLOUDLAB**

Address space:

`10.10.0.0/16`

Subnets:

| Subnet | Address Range |
|---|---|
| snet-management | 10.10.1.0/24 |
| snet-app | 10.10.2.0/24 |
| snet-db | 10.10.3.0/24 |

### Network Security Group

**NSG-CLOUDLAB-APP**

Inbound rules configured:

| Protocol | Port | Purpose |
|---|---:|---|
| TCP | 80 | HTTP |
| TCP | 443 | HTTPS |

The application subnet does not have an inbound rule allowing RDP (TCP 3389).

---

## 🌍 Web Server

IIS (Internet Information Services) was installed on the Windows Server virtual machine using PowerShell through **Azure Run Command**.

The default IIS website was replaced with a custom CloudLab page.

The application was tested through the VM public IP and successfully returned the web page.

### Application

The page displays:

- CloudLab
- Secure Web Application
- Running on Microsoft Azure
- Windows Server 2025 + IIS
- Environment: Lab

---

## 📊 Monitoring

Azure Monitor was configured to monitor the virtual machine.

Monitoring includes:

- VM availability
- CPU utilization
- Disk metrics
- Network metrics
- OpenTelemetry guest metrics
- Performance counters
- Recommended VM alerts

The monitoring configuration uses:

- Azure Monitor Workspace
- Data Collection Rule (DCR)
- OpenTelemetry

Process-level OpenTelemetry metrics were intentionally disabled to keep the laboratory focused and cost-conscious.

---

## 🔐 Security

Security measures implemented in the project include:

- Network segmentation using subnets
- Network Security Group (NSG) rules
- HTTP and HTTPS traffic control
- No inbound RDP rule on the application subnet NSG
- Secure Boot enabled
- vTPM enabled
- System-assigned Managed Identity
- Azure Monitor alerts
- Resource tagging

---

## 💰 Cost Management

The project was designed with Azure cost awareness in mind.

Cost-control practices used:

- Small VM size
- Automatic shutdown configured
- VM deallocated when not in use
- OS disk configured to be deleted with the VM
- Monitoring configured selectively
- Resources organized by project
- Resource tags used for identification and cost management

---

## 🏷️ Resource Tags

```text
Environment = Lab
Project     = CloudLab
CostCenter  = LAB-001
Owner       = David

---

## 📚 AZ-104 Skills Practiced

This project provided hands-on practice in several areas related to the AZ-104 certification.

### Compute
- Azure Virtual Machines
- Windows Server
- IIS
- VM configuration

### Networking
- Virtual Networks
- Subnets
- Network Security Groups
- Public and private IP addressing

### Identity & Governance
- Managed Identity
- Resource organization
- Resource tagging

### Monitoring
- Azure Monitor
- OpenTelemetry
- Performance metrics
- VM alerts

### Administration
- Azure Portalhttps://docs.github.com/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax
- PowerShell
- Azure Run Command
- Resource lifecycle management
- Cost management
https://chatgpt.com/c/6a8ba636-e838-83e9-8327-97b000bbc540#:~:text=%23%23%20%F0%9F%9A%A7%20Future%20Improvements%0A%0APlanned%20improvements%20for%20future%20versions%20of%20the%20project%3A%0A%0A%2D%20HTTPS%20with%20TLS%20certificate%0A%2D%20Azure%20Application%20Gateway%0A%2D%20Web%20Application%20Firewall%20(WAF)%0A%2D%20Private%20connectivity%0A%2D%20Azure%20Storage%20integration%0A%2D%20Infrastructure%20as%20Code%20with%20Bicep%0A%2D%20Automated%20deployment%0A%0A%2D%2D%2D


---
