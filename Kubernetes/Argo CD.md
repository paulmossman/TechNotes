**<span style="font-size:3em;color:black">Argo CD</span>**
***

"Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes."

# Glossary

| Term | Definition |
| ----------- | ----------- |
| CRD | Custom (Kubernetes) Resource Definition (file) |
| Application | A managed collection of manifests |
| Target State | The desired Application state, stored in Git |
| Live State | The actual (current) state of the Application in Kubernetes |
| Sync | The process of transitioning an Application's Live State to match its Target State, by applying changes in Kubernetes |
| Sync Status | Whether the Application's Live State to match its Target State |
| Sync Operation Status | Whether the SYnc has succeeded or failed |
| Health Status | Of the Application |
| Application source type | Tool used for building applications (Helm or Kustomize) |
| Refresh | Compare the latest Target State versus the Live State, and what is different |

# Funadamental Argo CD CRDs

## Application
Represents a deployed application instance in an environment.

**source**: Target State (Git)

**destination**: The target Kubernetes cluster and namespace.


## AppProject
Represents a logical grouping of applications.

## Repository credentials
The credentials for accessing private Git repositories.

Kubernetes Secrets and/or ConfigMaps, with a specific label:
```yaml
metadata:
  ...
  labels:
    argocd.argoproj.io/secret-type: repository
```

## Cluster credentials
The configuration for accessing multiple Kubernetes clusters.

Kubernetes Secret, with a specific label:
```yaml
metadata:
  ...
  labels:
    argocd.argoproj.io/secret-type: cluster
```

# Sync Wave
Split and order the manifests to be synched into "waves".  For example:
```yaml
metadata:
    annotations:
        argocd.argoproj.io/sync-wave: "2"
```
"0" is the default.  Values can be negative or positive.

# Resource Hooks
Run resources (usually Pods/Jobs) at various points during a Sync operation:
- PreSync
- Sync (after PreSync)
- PostSync (after Sync)
- SyncFail (if Sync failed)
- Skip (don't appy the manifest)

Deletion policy (optional):
- HookSucceeded
- HookFailed
- BeforeHookCreation 

For example:
```yaml
metadata:
    annotations:
        argocd.argoproj.io/hook: PostSync
        argocd.argoproj.io/hook-delete-policy: HookSucceeded
```

# ```argocd``` CLI tool
```bash
argocd app create \<Name\> --repo \<Repo URL\> --path \<Path in Repo\> --dest-server \<Kubernetes Cluster URL\> --dest-namespace \<Kubernetes Namespace\>
argocd app sync \<Name\>

```

# Plugins

Configured using ConfigMaps.

Types:
- Notification
- Image Updater
- ArgoCD Autopilot
- ArgoCD Interlace

# Admin

## Deploy Argo CD to Kubernetes
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd
```

## Access
Port forward the API service:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Keep this running, and open a new terminal.

Get the Admin Password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo
```

Access the UI at https://localhost:8080, and click through the TLS warning.  The Username is ```admin```.

Log in to the argocd CLI:
```bash
argocd login --insecure --grpc-web localhost:8080 --username admin --password \<Admin Password\>
```

# Configuration

## Add a User
```bash
kubectl edit cm argocd-cm -n argocd
```
Then (for username "developer") add:
```yaml
data:
  accounts.developer: login
```
Then set the password:
```bash
argocd account update-password --account developer --new-password \<Password\>
```

### RBAC rules
```bash
kubectl edit cm argocd-rbac-cm -n argocd
```
Then add:
```yaml
data:
  policy.default: role:readonly
  policy.csv: |
    p, role:synconly, applications, sync, */*, allow
    g, developer, role:synconly
```
This defines a role named ```synconly``` that only allows the ```sync``` action, granted to the ```developer``` user.

Reference: https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/ 

# ```argocd``` CLI

Reference: https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd/

