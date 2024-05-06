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
| Sync Status | Whether the Application's Live State metches its Target State |
| Sync Operation Status | Whether the Sync has succeeded or failed |
| Health Status | Of the Application |
| Application source type | Tool used for building applications from source |
| Refresh | Compare the latest Target State versus the Live State, and what is different |

# Architecture

3 main components:

## ArgoCD (API/Web) Server
gRPC/REST API server, used by the Web UI and ```argocd``` CLI

## ArgoCD Repo Server
Clones Git repos, and generates Kubernetes manifests.

## ArgoCD Application Controller
Gets the generated Kubernetes manifests from the Repo Server, and communicates with the Kubernetes API to get the current state and deploy changes.  Also detects out-of-sync.  Also invoked Resource Hooks.

# Funadamental Argo CD CRDs

## Application (kind)
Represents a deployed application instance in an environment.

**source**: Target State.  (The Git repository URL, path inside the repository, and revision.)

**destination**: The target Kubernetes cluster and namespace.

**project**: The ArgoCD project.

### Multiple Sources for an Application
Since v2.6, multiple sources can be combined into a single Application.  (Use ```sources```, instead of ```source```.)

A good use case: A public Helm chart, combined with override Values file from a private Git repository.

## AppProject (kind), aka Project
Represents a logical grouping of Applications.

Can restrict Git repos, Kubernetes clusters deployed into (and namespaces), Kubernetes resources types deployed.  Can create a Role for the Project's permissions.

A default Project named ```default``` is included.

## ApplicationSet (kind)
Represents a logical grouping of Applications, but support for multiple clusters and/or multi-tenant clusters.

Has generators to provide parameters that can be used in the Application templates:
- List
- Cluster
- Git
- Matrix (combines two other generators)
- others (Reference: https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators/)

Use Case (Cluster generator): Deploy an application into the "staging" cluster using HEAD, and into the "production" cluster using the "stable" branch.

## Repository credentials
The credentials for accessing private Git repositories.

Kubernetes Secret (and/or ConfigMap?), with a specific label:
```yaml
metadata:
  ...
  labels:
    argocd.argoproj.io/secret-type: repository
```

Supports HTTP (username/password), SSH (private key), GitHub (App credentials), or Helm (username/password, TLS certs).

Use a credential template (```argocd.argoproj.io/secret-type: repo-creds```) to re-use the same credentials for multiple repositories.

Reference: https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repositories

## Cluster credentials
The configuration for accessing multiple Kubernetes clusters.

Kubernetes Secret, with a specific label:
```yaml
metadata:
  ...
  labels:
    argocd.argoproj.io/secret-type: cluster
```

By default ArgoCD can use the cluster that it's deployed to.

# Operations

## Sync

### Option: Prune

Deletion of resources no longer defined in the Target State.

### Option: Automated Sync

Good use case: CI/CD pipelines don't need access to the Kubernetes cluster.

Required in order to rollback an Application.

#### Automated Pruning

Off by default for Automated Syncing, but can be enabled:
```yaml
  syncPolicy:
    automated:
      prune: true
```

#### Automated Self Healing

Making changes into the live Kubernetes cluster will take the Application OutOfSync.  But this (by default) won't trigger Automated Sync, unless Self Healing is enabled:
```yaml
  syncPolicy:
    automated:
      selfHeal: true
```

### Option: Create Namespace
```yaml
  syncOptions:
    - CreateNamespace=true
```  

### Other Sync Options

There's an annotation to exempt a Resource from being pruned.

Can disable ```kubectl``` validation, at Application or Resource level.

Selective Sync: Only Sync objects that are OutOfSync, to reduce ArgoCD (API/Web) Server load.

Prune Last: Prune only after all other waves have completed, at Application or Resource level.

Replace Resources instead of applying changes.

Others: https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options

## Tools

ArgoCD can autodetect, based on what files it finds.

### Helm
Options:
- Release Name
- Values file(s)
- Individual parameters (override from Values file)

Reference: https://argo-cd.readthedocs.io/en/stable/user-guide/helm/

### Kustomize
Many options.

Reference: https://argo-cd.readthedocs.io/en/stable/user-guide/kustomize/

### Directory of Files
Options:
- Recursive detection
- Include only certain files
- Exclude certain files

Reference: https://argo-cd.readthedocs.io/en/stable/user-guide/directory/

### YAML

### Jsonnet

Reference: https://argo-cd.readthedocs.io/en/stable/user-guide/jsonnet/

# Tracking Strategies

Reference: https://argo-cd.readthedocs.io/en/stable/user-guide/tracking_strategies/

For both: ```targetRevision:```.

## Git repository Tracking
- Commit SHA
- Tag
- Branch
- HEAD

## Helm repository Tracking
- Specific version
- Range
- Latest (can include or not include pre-releases)


# Sync

Apply order:
1. Sync Phase
2. Sync Wave (lowest first)
3. Kubernetes Kind (starting with Namespace)
4. Alphabetical name

i.e. All Waves in the PreSync Phase are completed, and then the first Wave of the Sync Phase is started.

## Sync Wave
Split and order the manifests to be synched into "waves".  For example:
```yaml
metadata:
    annotations:
        argocd.argoproj.io/sync-wave: "2"
```
"0" is the default.  Values can be negative or positive.  Default delay of 2s between waves.

## Sync Phases
1. PreSync
2. Sync
3. PostSync

## Resource Hooks
Run resources (usually Pods/Jobs) at various points during a Sync operation:
- Phases:
    - PreSync
    - Sync (after PreSync)
    - PostSync (after Sync)
- SyncFail (if Sync failed)
- Skip (don't appy the manifest)

Deletion policy for the Resources (optional):
- HookSucceeded: Deleted after hooks succeeds
- HookFailed: Deleted if the hook fails.
- BeforeHookCreation: Existing is deleted before a new is created.  (default)

For example:
```yaml
metadata:
    annotations:
        argocd.argoproj.io/hook: PostSync
        argocd.argoproj.io/hook-delete-policy: HookSucceeded
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
Port forward the ArgoCD (API/Web) Server service:
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
This defines a Role named ```synconly``` that only allows the ```sync``` action, granted to the ```developer``` user.

Roles can also be create inside Projects, then create a JWT:
```bash
argocd proj role create-token <Project> <Role>
```

Reference: https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/ 

# ```argocd``` CLI

Examples:
```bash
argocd app create \<Name\> --repo \<Repo URL\> --path \<Path in Repo\> --dest-server \<Kubernetes Cluster URL\> --dest-namespace \<Kubernetes Namespace\>
argocd app sync \<Name\>
```

Reference: https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd/

Option: ```--auth-token```, to specify a JWT create from a Role.
