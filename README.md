# Windows Server & Active Directory Sandbox Lab

## Project Overview
This project demonstrates the deployment and configuration of a virtualized enterprise network infrastructure. I designed and built an isolated lab environment featuring a Windows Server 2022 Domain Controller and a Windows 11 Enterprise client. The primary objective was to simulate a production corporate IT environment to gain hands-on experience with Active Directory Domain Services (AD DS), automated core directory management, network routing, and centralized security policy enforcement.

---

## Technical Stack & Competencies
* **Hypervisor:** Oracle VirtualBox
* **Directory Services:** Active Directory Domain Services (AD DS), Windows DNS Server
* **Operating Systems:** Windows Server 2022 Standard Evaluation, Windows 11 Enterprise
* **Automation:** Advanced PowerShell Scripting

---

## Topology & Network Architecture
The environment uses a dedicated, isolated virtual local area network (VLAN) topology with an external NAT gateway to facilitate controlled internet routing and DNS forwarding.

* **Subnet:** `192.168.10.0/24` (Configured via VirtualBox NAT Network)
* **Domain Controller (`DC-01.lab.local`):**
  * **Static IP Address:** `192.168.10.10`
  * **Default Gateway:** `192.168.10.1`
  * **Active Roles:** AD DS, DNS Server (with external forwarders pointed to `dns.google`)
* **Workstation Client (`Win11-Client01`):**
  * **Static IP Address:** `192.168.10.20`
  * **Primary DNS Server:** `192.168.10.10` (Pointed to the Domain Controller for local record resolution)

---

## Key Implementation Milestones

### 1. Core Active Directory & DNS Infrastructure Deployment
* Initialized the physical hypervisor virtual routing switch to anchor the custom `192.168.10.0/24` network framework.
* Provisions static IPv4 assignments and loopback architectures on the base server operating system.
* Promoted the standalone server to an authoritative Domain Controller, bootstrapping the root forest domain `lab.local`.
* Established stable external internet connectivity across the isolated subnet by creating upstream DNS Forwarders to public DNS architectures.

### 2. Automation: Bulk Identity & Access Provisioning
To eliminate repetitive manual tasks, I developed and executed an optimized PowerShell pipeline script. The automation script programmatically generates specific corporate Organizational Units (OUs) and automatically provisions 50 unique test user accounts dynamically distributed across designated business departments with explicit security credentials.

> 🛠️ **View the Automation Script:** [PowerShell Provisioning Code File](./scripts/create-ad-users.ps1)

#### Directory Verification (ADUC)
The following capture validates the precise implementation of the target OUs and automated account instantiation:

![Active Directory Users and Computers Setup Verification](images/aduc-users-created.png)

### 3. Workstation Integration & Domain Join Validation
* Reconfigured the Windows 11 system adapter properties to register appropriately with the enterprise DNS hierarchy.
* Authenticated and joined the workstation machine cleanly to the `lab.local` active administrative root forest.

#### Core Network Configuration
Verification of the final workstation network interface layout using `ipconfig /all`:

![Windows 11 IP Interface Settings Validation](images/client-ip-configuration.png)

#### Active Domain Integration Proof
System property verification confirming successful target domain join execution:

![Windows 11 System Properties Domain Authentication](images/win11-domain-join.png)

#### User Session & Credential Resolution Validation
Active terminal verification using the Full Distinguished Name lookup to prove a domain user account (`user1`) is fully authorized and logged in on the local machine:

![Distinguished User Name Authentication Terminal Output](images/client-whoami-validation.png)

### 4. Enterprise Security Baseline Enforcement (Group Policy)
* Architected custom Group Policy Objects (GPOs) to maintain uniform network-wide workstation baselines.
* Configured advanced security policies to restrict operational access to administrative tools (e.g., Control Panel, Registry) for non-administrative profiles.
* Engineered logon scripts to mount targeted, persistent mapped shared enterprise storage paths based on group delegation.
