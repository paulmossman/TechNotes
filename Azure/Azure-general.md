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
Azure Portal: Privileged Identity Management → Tasks → My roles → Activate → Microsoft Entra roles → Eligible assignment → (table entry) "Activate" link

### Also, expose hidden Subscriptions
Microsoft Entra ID -> Manage dropdown in left -> Properties -> (way at the bottom) Access management for Azure resources (enable the toggle)


### also, 

PIM > Manage > Azure resources > Subscriptions (drop-down)

## App vs SP credentials

App credentials:
- viewable in the portal
- can be used cross tenant if the app has a linked SP in the tenant

SP credentials:
- not viewable in the portal
- tenant local

# Hierarchy
Account → Directory / Tenant (w a Domain) → Subscription → Resource Group → Resource
