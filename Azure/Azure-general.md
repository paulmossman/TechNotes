**<span style="font-size:3em;color:black">Azure General</span>**
***

# IAM

## Roles
Two types:
- Active Directory (AD)
- Role Based Access Control (RBAC)

## PIM (Privileged Identity Management)

Not actually part of Azure.  (Part of Microsoft Entra ID.)  Used by Azure, but also other services.

"Manage, control, and monitor access to important resources in your organization", Reference: https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure

### Activate a role
Azure Portal: Privileged Identity Management → Tasks → My roles → Activate → Microsoft Entra roles → Eligigle assignment → (table entry) "Activate" link

# Hierarchy
Account → Directory / Tenant (w a Domain) → Subscription → Resource Group → Resource
