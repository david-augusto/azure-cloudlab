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
- Cost-aware resource management

---

## 🏗️ Architecture

```text
                         Internet
                            │
                            │ HTTP
                            ▼
                    ┌───────────────┐
                    │   Public IP   │
                    └───────┬───────┘
                            │
                            ▼
              ┌──────────────────────────┐
              │ Azure Virtual Network    │
              │ 10.10.0.0/16            │
              │                          │
              │  ┌────────────────────┐  │
              │  │ snet-app            │  │
              │  │ 10.10.2.0/24       │  │
              │  │                    │  │
              │  │  ┌──────────────┐  │  │
              │  │  │ WEB-01       │  │  │
              │  │  │ Windows 2025 │  │  │
              │  │  │ IIS          │  │  │
              │  │  └──────────────┘  │  │
              │  └────────────────────┘  │
              └──────────────────────────┘
                            │
                            ▼
                    Azure Monitor
🖥️ Virtual Machine
Property	Configuration
Name	WEB-01
Operating System	Windows Server 2025 Datacenter: Azure Edition
Size	Standard_DC1ds_v3
vCPU	1
Memory	8 GiB
Region	East US
Private IP	10.10.2.4
Web Server	IIS
Secure Boot	Enabled
vTPM	Enabled
Managed Identity	System-assigned
🌐 Networking
Virtual Network

VNET-CLOUDLAB

Address space:

10.10.0.0/16

Subnets:

snet-management → 10.10.1.0/24
snet-app        → 10.10.2.0/24
snet-db         → 10.10.3.0/24
Network Security Group

NSG-CLOUDLAB-APP

Inbound rules configured:

Protocol	Port	Purpose
TCP	80	HTTP
TCP	443	HTTPS

The application subnet does not have an inbound rule allowing RDP (TCP 3389).

🌍 Web Server

IIS was installed on Windows Server using PowerShell through Azure Run Command.

The web server was tested through the VM public IP.

The deployed page displays:

CloudLab
Secure Web Application
Running on Microsoft Azure
Windows Server 2025 + IIS
Environment: Lab
📊 Monitoring

Azure Monitor was configured for the virtual machine.

Monitoring includes:

VM availability
CPU utilization
Disk metrics
Network metrics
OpenTelemetry guest metrics
Performance counters
Recommended VM alerts

The configuration uses an Azure Monitor Workspace and a Data Collection Rule (DCR).

Process-level OpenTelemetry metrics were intentionally not enabled to keep the lab focused and cost-conscious.

🔐 Security

Security measures implemented in the project include:

Network segmentation using subnets
NSG-based inbound traffic control
No inbound RDP rule on the application subnet NSG
Secure Boot enabled
vTPM enabled
System-assigned Managed Identity
Azure Monitor alerts
Resource tagging
💰 Cost Management

The project was built with Azure cost awareness in mind.

Practices used:

Small VM size
Automatic shutdown configured
VM deallocated when not in use
OS disk configured to be deleted with the VM
Monitoring configured selectively
Resources organized by project
Resource tags used for identification and cost management
🏷️ Resource Tags
Environment = Lab
Project     = CloudLab
CostCenter  = LAB-001
Owner       = David
📚 AZ-104 Skills Practiced

This project provides hands-on practice related to several AZ-104 areas.

Compute
Azure Virtual Machines
Windows Server
IIS
VM configuration
Networking
Virtual Networks
Subnets
Network Security Groups
Public and private IP addressing
Identity & Governance
Managed Identity
Resource organization
Resource tagging
Monitoring
Azure Monitor
OpenTelemetry
Performance metrics
VM alerts
Administration
Azure Portal
PowerShell
Azure Run Command
Resource lifecycle management
Cost management
🚧 Future Improvements

Planned improvements for future versions of the project:

HTTPS with TLS certificate
Azure Application Gateway
Web Application Firewall (WAF)
Private connectivity
Azure Storage integration
Infrastructure as Code with Bicep
Automated deployment
🇧🇷 Português
🎯 Objetivo do Projeto

Construir e administrar um pequeno ambiente de aplicação web no Microsoft Azure, aplicando conceitos práticos de administração de Cloud, redes, segurança, monitoramento e gerenciamento de custos.

O projeto demonstra a implementação de:

Azure Virtual Machines
Azure Virtual Network
Network Security Groups (NSG)
Windows Server 2025
Servidor Web IIS
Endereçamento IP público e privado
Azure Monitor
Métricas OpenTelemetry
Managed Identity
Tags de recursos
Gerenciamento de custos
🏗️ Arquitetura
                         Internet
                            │
                            │ HTTP
                            ▼
                    ┌───────────────┐
                    │    IP Público │
                    └───────┬───────┘
                            │
                            ▼
              ┌──────────────────────────┐
              │ Azure Virtual Network    │
              │ 10.10.0.0/16            │
              │                          │
              │  ┌────────────────────┐  │
              │  │ snet-app            │  │
              │  │ 10.10.2.0/24       │  │
              │  │                    │  │
              │  │  ┌──────────────┐  │  │
              │  │  │ WEB-01       │  │  │
              │  │  │ Windows 2025 │  │  │
              │  │  │ IIS          │  │  │
              │  │  └──────────────┘  │  │
              │  └────────────────────┘  │
              └──────────────────────────┘
                            │
                            ▼
                    Azure Monitor
🖥️ Máquina Virtual
Propriedade	Configuração
Nome	WEB-01
Sistema Operacional	Windows Server 2025 Datacenter: Azure Edition
Tamanho	Standard_DC1ds_v3
vCPU	1
Memória	8 GiB
Região	East US
IP Privado	10.10.2.4
Servidor Web	IIS
Secure Boot	Habilitado
vTPM	Habilitado
Managed Identity	Atribuída pelo sistema
🌐 Rede
Virtual Network

VNET-CLOUDLAB

Espaço de endereçamento:

10.10.0.0/16

Sub-redes:

snet-management → 10.10.1.0/24
snet-app        → 10.10.2.0/24
snet-db         → 10.10.3.0/24
Network Security Group

NSG-CLOUDLAB-APP

Regras de entrada configuradas:

Protocolo	Porta	Finalidade
TCP	80	HTTP
TCP	443	HTTPS

A NSG da subnet da aplicação não possui uma regra de entrada permitindo RDP (TCP 3389).

🌍 Servidor Web

O IIS foi instalado no Windows Server utilizando PowerShell através do Azure Run Command.

O servidor web foi testado através do IP público da máquina virtual.

A página publicada apresenta:

CloudLab
Secure Web Application
Running on Microsoft Azure
Windows Server 2025 + IIS
Environment: Lab
📊 Monitoramento

O Azure Monitor foi configurado para a máquina virtual.

O monitoramento inclui:

Disponibilidade da VM
Utilização de CPU
Métricas de disco
Métricas de rede
Métricas de convidado via OpenTelemetry
Contadores de desempenho
Alertas recomendados para a VM

A configuração utiliza um Azure Monitor Workspace e uma Data Collection Rule (DCR).

As métricas OpenTelemetry por processo foram intencionalmente desabilitadas para manter o laboratório focado e com atenção aos custos.

🔐 Segurança

Medidas de segurança implementadas:

Segmentação de rede utilizando sub-redes
Controle de tráfego de entrada através de NSG
Ausência de regra de entrada para RDP na NSG da subnet da aplicação
Secure Boot habilitado
vTPM habilitado
Managed Identity atribuída pelo sistema
Alertas do Azure Monitor
Tags nos recursos
💰 Gerenciamento de Custos

O projeto foi desenvolvido considerando o controle dos custos no Azure.

Práticas utilizadas:

Máquina virtual de pequeno porte
Desligamento automático configurado
VM desalocada quando não está em uso
Disco do sistema configurado para exclusão junto com a VM
Monitoramento configurado de forma seletiva
Recursos organizados por projeto
Tags utilizadas para identificação e controle de custos
🏷️ Tags dos Recursos
Environment = Lab
Project     = CloudLab
CostCenter  = LAB-001
Owner       = David
📚 Conhecimentos Praticados para AZ-104

Este projeto proporciona prática em diferentes áreas cobradas na AZ-104.

Computação
Azure Virtual Machines
Windows Server
IIS
Configuração de VMs
Redes
Virtual Networks
Subnets
Network Security Groups
IP público e privado
Identidade e Governança
Managed Identity
Organização de recursos
Tags
Monitoramento
Azure Monitor
OpenTelemetry
Métricas de desempenho
Alertas de VM
Administração
Azure Portal
PowerShell
Azure Run Command
Gerenciamento do ciclo de vida dos recursos
Controle de custos
🚧 Próximas Melhorias

Melhorias planejadas para versões futuras:

HTTPS com certificado TLS
Azure Application Gateway
Web Application Firewall (WAF)
Conectividade privada
Integração com Azure Storage
Infrastructure as Code com Bicep
Deploy automatizado
👨‍💻 Author / Autor

David Augusto

IT Support | Azure Cloud | Microsoft 365 | Active Directory

Currently preparing for / Atualmente estudando para:

Microsoft Certified: Azure Administrator Associate (AZ-104)

GitHub: https://github.com/david-augusto
LinkedIn: https://www.linkedin.com/in/davidaugusto1/
