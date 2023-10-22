**<span style="font-size:3em;color:black">Kubernetes General</span>**
***

# Pod (a kind)

A Kubernetes encapsulation of one or more Containers.  A single instance of an application.

***Cannot*** be edited.  Delete and re-create instead.

In practice it's almost always only one Container per Pod.  If more, then it would be a supporting Container and not a duplicate of the same Container.

## Multi-Container Pods
Design Patterns:
1. Adaptor: transform output
2. Ambassador: proxy a local outgoing connection
3. Sidecar: enhance or extend

([Reference](https://kubernetes.io/blog/2015/06/the-distributed-system-toolkit-patterns/))

## Network

All Containers in the same pod share a single 'localhost'.  i.e. If one Container binds to port 80, then no other Container can.  But all Containers in the port can reach that port via "localhost:80".

The Pod's name is also a DNS entry.

## Volumes

Each Container can mount the Pod's Volumes.

## Scratch Volume
(Versus PersistantVolume...)

```yml
   # (Pod)
      volumes:
      - name: scratch
        emptyDir: {}
```        
https://kubernetes.io/docs/concepts/storage/volumes/#emptydir

# Container Resources

Can set "Request" and/or "Limit".

## Enforcement

### CPU

The Container won't be able to use more that the limit.  i.e. Throttled.

### Memory

If the Container uses more than the limit, then it'll be killed.  Reason: ```OOMKilled```.

## LimitRange (a kind)

Set default, max, and min for all newly created Pods in the namespace.

## ResourceQuota (a kind)

Enforce various ***total*** limits at the ***Namespace*** level.  Can be Compute (CPU, Memory), Storage, or Object Count.


# ReplicaSet (a kind)

Keeps right # of Pods running.  Load Balancing and Scaling.

```kubectl explain rs.spec.selector``` → Match the Pod template's label.

OLD: Replication Controller

# Deployment (a kind)

A wrapper for Pods and ReplicaSets.  Allows "rollout" of a series of changes ***together***, or "rollback" to an old version.    Rollouts have incremental Revisions: 1, 2, 3, ...

https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

***Can*** be edited, which causes rollout of a new ReplicaSet.  Or: ```kubectl apply -f deployment.yml```

Update strategies:
1. ```RollingUpdate``` (default) - "Roll" replacements in batches (configurable size, etc.)
2. ```Recreate``` - Destroy all old at once, i.e. downtime.

Rollback: ```kubectl rollout undo <Deployment name>```  This changes the # of the Revision rolled back to, to be the next Revision #.

# StatefulSet (a kind)

Similar to Deployment, but Pods are (optionally) created in a specific order.  Each Pod gets a unique ordinal index, which becomes part of the Pod name.  (Versus the random names used in Deployments.)

# Services

Enable communications between various components/users of the application.  Allows communictions to other components, e.g user endpoints, other pods, DBs.  Types:
1. NodePort
1. ClusterIP
1. LoadBalancer

Each Service has an IP address, and it's name is also a DNS entry.

```Endpoints:```  → All the destinations that traffic could be forwarded to.

```bash
k get ep
```

## NodePort (a kind)

Listens to a Port on Nodes (in the range 30000-32767), forwards to a port on a Target(s) inside those Nodes.

Hit at http://<Node IP>:<NodePort>

The Target is identified by a ```selector:``` corresponding to label(s).

Multiple Targets → Requests are randomly distributed.

Multiple Nodes in the Cluster → The same port on all the Nodes.  i.e. The NodePort service automatically spans all the Nodes.

## ClusterIP (a kind)

A virtual IP within a Cluster.  (The default ```type:``` for ```Service```.)

Consider creating with ```kubectl expose ...``` instead of ```kubectl create svc ...```, because the former will set the right Selector Labels.

### Headless Service

```clusterIP: None```

Creates DNS records for ***each*** Pod, instead of a single DNS and IP that's then load balanced to all Pods.  Use with StatefulSet, and ```serviceName:```.

## LoadBalancer (a kind)

In supported cloud providers.

Basically a NodePort (with port in the range 30000-32767), plus a Load Balancer that forwards to it.

# Ingress

A Layer 7 Load Balancer configurable directly in Kubernetes, with URL path routing and SSL certificates.  (Since port range 30000-32767.)

[Reference](https://kubernetes.io/docs/concepts/services-networking/ingress/)

## Ingress Controller

Implemented using [NGINX](https://www.nginx.com/), [HAProxy](https://www.haproxy.org/), [Traefik Proxy](https://traefik.io/traefik/), or [Istio](https://istio.io/).

Not included in Kubernetes.  You would need to deploy one yourself, (```kind: Deployment```)  

Google Cloud: [Google Kubernetes Engine (GKE) Ingress](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress)

Requires a ```ConfigMap``` of configuration, a ```NodePort``` to expose, and a Serviec Account with permissions to access the Kubernetes objects.

## Ingress Resource (a kind)

The configuration in Kubernetes.  Forward to a Service.

```kubectl explain ingress```

Various Controller-specific ```ingress.metadata.annotations``` can be used to control some behaviour, notably re-writing the target path.  For example: [NGINX](https://kubernetes.github.io/ingress-nginx/examples/rewrite/).

# Job (a kind)

A workload that is meant to perform a specific task, and then exit.

Versus a ReplicaSet, a Job runs a set of Pods (with ```restartPolicy: Never```) to completion.

# CronJob (a kind)

Like Linux crontab.

```spec.schedule``` → crontab syntax

```spec.jobTemplate.spec``` → Matches Job ```spec```

# NetworkPolicy (a kind)

Applies to Pods using ```podSelector:``` and the Labels on Pods.

By default applies to matching Pods in all namespaces.  Use ```namespaceSelector``` to restrict that.

Use ```ipBlock``` to apply to IPs outside of the Cluster.

```egress``` and ```ingress``` are arrays of rules, ```NetworkPolicyEgressRule``` and ```NetworkPolicyIngressRule``` respectively.  The rules are ***OR'd***.

Each rule has a ```port``` array and a "peer" array, which is ```from``` (source) for Ingress and ```to``` (destination) for Egress.  

```from[]``` and ```to[]``` are themselves arrays, which can have entries for ```ipBlock```,  ```namespaceSelector```, and/or ```podSelector```.  The entries in these arrays are ***AND'd***.

policyTypes: An array, can contain ```Ingress``` and/or ```Egress```.

Enforced by the network solution implemented on the cluster, and not all support it.  (e.g. Flannel does not.)

# PersistentVolume (a kind)

Same types as Pod volume.

Cluster-scoped.


## PersistentVolumeClaim (a kind)

A Pod can then "claim" a PersistentVolume, 1:1.  Can match based on request/capacity, or selectors and labels.

A PersistentVolumeClaim is one of the Volume types of a Pod.

Namespace-scoped.

### volumeClaimTemplate

Templatize the PersistentVolume and PersistentVolumeClaim creation upon StorageClass in a StatefulSet.

# Role-based access control (RBAC)

## Role (a kind)
Has a ```rules:``` section, instead of ```spec:```.

Scoped to a namespace.

### RoleBinding (a kind)
Attach a Role to a user or set of users, scoped to a namespace.

But ```subjects:``` and ```roleRef:``` sections, instead of ```spec:```.

## ClusterRole (a kind)
Like Role, except not scoped to a namespace.  i.e. Control access to Cluster-scoped resources.

Has a ```rules:``` section, instead of ```spec:```.

### ClusterRoleBinding (a kind)
Attach a ClusterRole to a user or set of users, Cluster-scoped.

But ```subjects:``` and ```roleRef:``` sections, instead of ```spec:```.

# Secrets
Not actually very secret by default, just base64 encoded, so easy to decode.  Some special treatment (only given to pods that request them, not written to disk.)

The default Kubernetes secrets system just ```base64``` encoded (***not*** encrypted), so development and testing only.

For Production secrets use Helm Secrets, HashiCorp Vault (plus [Vault Provider](https://github.com/hashicorp/vault-csi-provider)), [AWS Provider](https://github.com/aws/secrets-store-csi-driver-provider-aws) (a wrapper to AWS Secrets Manager), others...  Or [Enable Encryption at Rest for Secrets](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).

A single "Secret" contains one or more Keys (Key/Value pairs.)

Secrets can be injected into a Container (in a Pod):
- Environment variables:
   - all
   - a specific
- Volume, with each Key as a file: ```volumes:``` / ```secret:``` / ```secretName:```

An Pod that's created in the Namespace can access any of the Namespace's Secrets.

View (base64 encoded) all values in a secret:
```
kubectrl get secret <name> -o yaml
```
(In the ```data:``` section.)

# Namespaces

Can of course be created.

## Included at Cluster startup

### default
Used when no --namespace option is provided.
### kube-system
For running Kubernetes, don't touch it.
### kube-public
Resources that should be made available to all.

## DNS

Reminder: Each Pod and Service name is also a DNS entry.

FQDN: <Pod/Service Name>.<Namespace>.svc.cluster-domain.example

# Admissions Controllers
Allow enforcing certain security items that can't be done through RBAC.  e.g. Change request, restrictions on Docker images pulled, limit event rates, validate/reject requests.

Built-in Admissions Controller that's enabled by default: ```NamespaceLifecycle```.

"Mutating" Admission Controller: Can change the request.  "Validating" Admission Controller: Can check the request, and allow/deny.  (Can be both.)

You can implement your own using: ```MutatingAdmissionWebhook``` or ```ValidatingAdmissionWebhook``` 

# Probes

Readiness and Liveness

Types:
- HTTP
- TCP
- Command

Explain: 
- pod.spec.initContainers.readinessProbe
- pod.spec.initContainers.livenessProbe

# Scheduling and Eviction

## Taints and Tolerations

A named Taint can be placed on a Node.  Pods that don't have a corresponding named Toleration are subject to the Taint Effect:
- ```NoSchedule```: A new Pod is not scheduled on the Node.
- ```PreferNoSchedule```: A new Pod may be scheduled on the Node if it can't be scheduled elsewhere.
- ```NoExecute```: A new Pod is not scheduled on the Node, and existing Pods are evicted.

## Node Selectors

```nodeSelecter``` lists Key-Value pairs that correspond to Labels for the Node(s) that you want the Pod to run on.  Very simple.

## Node Affinity

More advanced than Node Selectors.  e.g. And, Or, Not, ... Scheduling and/or Execution.

Affinity and anti-Affinity.

# YAML

Four top-level fields:
1. apiVersion:
2. kind:
3. metadata:
4. spec:

## Structure
apiVersion:
kind: # https://kubernetes.io/docs/concepts/overview/working-with-objects/, options: ```kubectl api-resources```
metadata:
   name: <Name>
   namespace: <Namespace>
   labels:
      # User-defined
      app: myApp
      type: backEnd
spec:

## Containers

YAML ```spec``` / ```containers``` / <item> section:
- ```command:``` (string array) - Override ENTRYPOINT
- ```args:``` (string array) - Override CMD (not including ENTRYPOINT)

YAML ```spec``` / ```env:``` for Environment Variables:
- ```name:```
- ```value:```
or
- ```valueFrom:``` a ```configMapKeyRef:``` or a ```secretKeyRef:```

# Security

Docker security settings can all be configured in Kubernetes, at either the Pod or Container level.  (Pod overrides Container.)  YAML: ```securityContext:```.

## Service Account

(Versus a User Account.)

An object that can be created.  You can create a [JWT](https://jwt.io/) that's stored as a Secret.  e.g. For use in the "Authorizaton: Bearer XXX" header in a REST request to the Kubernetes API server.  Before v1.24 the JWT was created implicitly, and didn't expire.

Use the TokenRequest API to get updated JWTs.

There's a ```default``` Service Account, which is has restricted permissions (basic query only.)

# Metrics 

Popular, comprehensive, open-source: [Prometheus](https://prometheus.io/)

## Metric Server

Basic in-memory storage only (not historical.)  Optional, not installed by default.  Install from [GitHub](https://github.com/kubernetes-sigs/metrics-server/blob/master/README.md).

Use:
```
kubectl top node
kubectl top pod
```

# Interact with the API server
```bash
kubectl proxy 8001 &
curl localhost:8001/apis
curl localhost:8001/apis/authorization.k8s.io
```

# Administration

## Upgrade

https://kubernetes.io/docs/home/, and search for "Upgrade".

But to avoid downtime you would need to drain nodes before upgrading them!  e.g.:
```bash
kubectl drain <nodename> --ignore-daemonsets
```
Afterwards:
```bash
kubectl uncordon <nodename>
```

To see your options:
```bash
kubeadm upgrade plan
```

## Backup & Restore (if you manage your Kubernetes service)
The data directory of the ETCD server.

Backup into a file:
```bash
etcdctl snapshot save <filename>
```

Status of a file: 
```bash
etcdctl snapshot status <filename>
```

Restore from a file:
```bash
service kube-apiserver stop
etcdctl snapshot restore <filename> --data-dir <new data dir> # Creates NEW
# Edit etcd.server → --data-dir=<new data dir>   /etc/kubernetes/manifests/etcd.yaml
systemctl daemon-reload
service etcd restart
service kube-apiserver start
```

Note, required etcdctl options:
```bash
--cacert
--cert
--endpoints=[127.0.0.1:2379]
--key
```
