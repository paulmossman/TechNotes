**<span style="font-size:3em;color:black">Azure General</span>**
***

# Azure Portal

## Direct URLs
A tentant: https://portal.azure.com/\<Tenant ID>
A Resource Group: https://portal.azure.com/#@${TENANT_ID}/resource/subscriptions/${SUBSCRIPTION_ID}$/resourceGroups/${RG}/overview
Enterprise Application "Users and groups": https://portal.azure.com/${EA_TENANT_ID}/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Users/objectId/${EA_OBJECT_ID}/appId/${EA_CLIENT_ID}/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/

# IAM

## Roles
Two types:
- Active Directory (AD)
- Role Based Access Control (RBAC)

## Assign a Role - Subscription Scope
In the # navigate to Home → Subscriptions → the Subscription → Access control (IAM) → Grant access to this resource "Add role assignment" button → (Role) "Privileged administrator roles" tab → (search) the role, select it, "Next" button → (Members) "+ Select members" → (search) the member, select it, "Select" button → "Next" button → (Conditions) What user can do "Allow user to only assign selected roles to selected principals (fewer privileges)", then "+  Select roles and principals" → in "Constrain roles" section, click "Configure" button → "+ Add role" → (search and select) the role → "Save" → "Save" → "Review + assign" button x 2.

### View Role Assignement - Subscription Scope
In the portal navigate to Home → Subscriptions → the Subscription → Access control (IAM) → "Role assignments" tab → (search) the member.


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
