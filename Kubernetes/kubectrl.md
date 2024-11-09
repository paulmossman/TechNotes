**<span style="font-size:3em;color:black">kubectl</span>**
***

# Reference

https://kubernetes.io/docs/reference/

https://kubernetes.io/docs/reference/kubectl/cheatsheet/

# Top Level
Brief info:
```
kubectl get <all / rs / po / deploy / __>
```
Use ```--no-headers``` to omit headers, which is useful for counting the number of items.

Detailed info:
```
kubectl describe <all / rs / po / deploy / __>
```

Delete a resource (aka object):
```
kubectl delete <rs / po / deploy / __> [Name]
```

Apply (or Create if it doesn't already exist) from JSON/YAML (Declarative):
```
kubectl apply -f ___.yaml
```

Expose a Pod named 'deployment' via a port:
```
kubectl expose deployment <Pod> --port <Port>
```
The default Type is ClusterIP


See: https://kubernetes.io/docs/tutorials/stateless-application/expose-external-ip-address/

Create a Pod:
```
kubectl run <Name> --image=<Image>
```
Think of it as ```kubectl create pod```, but note that you don't include ```pod``` with ```run```.  (If you do, then you'll get a Pod named ```pod```.)

With port exposed (via an implicitly created clusterIP service):
```
kubectl run httpd --image nginx --port=80 --target-port=80 --expose=true
```

Temporary, to run a single command and then delete afterwards:
```
kubectl run tmp --restart=Never --rm -i --image nginx:alpine -- curl google.com
```
Quickly repeat:
```
export tmp="kubectl run tmp --restart=Never -i --rm --image"
ubuntu@pamocavm:~$ $tmp nginx:alpine -- curl google.com
```


Create a Pod with command:
```
kubectl run hello-test --image alpine --command -- sh -c "while true; do echo hello; sleep 10;done"
kubectl logs pod/hello-test -f
```

Explain YAML (including apiVersion):
```
kubectl explain <rs / po / deploy / deploy.spec / __> [--recursive]
```

Edit an existing (running) Resource:
```
kubectl edit <rs / po / deploy / __> [Name]
```

Taint a Node:
```
kubectl taint nodes node1 key1=value1:NoSchedule
```

To remove a Taint use the command to create it, but with ```-``` as a suffix.

Untaint a Node:
```
kubectl taint nodes node1 key1=value1:NoSchedule-
```

Execute a command inside a Container:
```
kubectl exec <Pod name> [-c <Container name, if 2+ containers>] -- whoami
```

Common example, run an interactive shell:
```
kubectl exec -it <Container name> -- sh
```

Logs:
```
kubectl logs -f <Pod name> [<Container name, if 2+ containers>]
```
Helpful when the log file itself doesn't have date/time:
```
--timestamps
```

# Deployments
```
kubectl rollout status <Deployment name>
kubectl rollout history <Deployment name>
```

# Ingress
```
kubectl create ingress ingress-test --rule="store.example.com/checkout*=checkout-service:80"
```

# Top Level Options

Labels:
```
--show-labels 
```

## Context
List available contexts:
```
kubectl config get-contexts
```

Get the current context:
```
kubectl config current-context
```

Switch the current context:
```
kubectl config use-context <Context Name>
```

## Namespace
```
--namespace=___
```
If omitted, then "default" is assumed.

```
--all-namespaces
```

Override 'default' namespace:
```
kubectl config set-context $(kubectl config current-context) --namespace=my-namespace
```

## Output Format
```
-o json

-o jsonpath <JSONPath>

-o wide  # Extra info

-o yaml
```

## Help
Very useful for seeing the options:
```
--help
```

# Resources
Get a list of all supported resources, including their short names:
```
kubectl api-resources
```

Though **not** Ingress Resources...

# dry-run → YAML
```
kubectl <Options> --dry-run=client -o yaml > deployment.yaml
```

Example:
```
kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
```

# Dump YAML for existing Pod
```
kubectl get pod <pod-name> -o yaml > nginx-deployment.yaml
```


# Using Edit, and then Replace
First use ```edit```, and change something that can't be changed.  Save fails, but creates a ```/tmp/kubectrl-edit-___.yaml```.

Then run:
```bash
kubectl replace --force -f /tmp/kubectrl-edit-___.yaml
```
(This deletes and re-creates from new!)

# Retrieve all resources
```bash
kubectl get all --all-namespaces -o yaml > all.yml
```

# Frequent
```
kubectl get pods
kubectl get pods -o wide  # Include IP and Node
kubectl get pods \<Pod name\> 
kubectl get pods --selector key1=value1,key2=value2 # Get by labels
kubectl delete pod \<Pod name\>
kubectl get all -o wide
```
```
kubectl get replicationcontroller
```
```
kubectl explain replicaset # Yaml details
kubectl get rs
kubectrl create -f replicaset.yml

kubectrl replace -f replicate-set.yml
kubectl scale replicaset --replicas=5 \<ReplicaSet name\>
kubectl delete replicaset \<ReplicaSet name\>
kubectl edit replicaset \<ReplicaSet name\>

```

# Config
```bash
kubectl config view
```
Default file: ~/.kube/config

```kind: Config```, but not a object that's created.

Certificate authority file "data" content: Must be ```base64``` encoded, not raw.

# Kubernetes YML file

All have 4 sections:
 - apiVersion:
 - kind:
 - metadata: 
 - spec:

# Create Pod YML
```
kubectl run web-server --image=nginx --dry-run=client -o yaml > pod.yml
```
THEN use 'apply' to create

# Create a Pod

Prefer 'kubectl apply -f pod.yml' (vs. 'kubectl create ...'), so that 'apply' can subsequently be called without a warning.

# Create a ConfigMap:
```
kubectl create configmap <name>
```

Followed by either:
```
--from-literal=VAR1,Value1 --from-literal=VAR2,Value2
```
or:
```
--from-file=app.properties
```

## Use a ConfigMap in a Pod YAML spec (Container):
```
   envFrom:
      - configMapRef:
         name: <name>
```
Or if just one Key:
```
   env:
     - name: <Env Var name>
       valueFrom:
         configMapKeyRef:
           name: <ConfigMap name>
           key: <Key name>
```


# Create a Secret
```bash
kubectl create secret generic prod-db-secret --from-literal=username=produser --from-literal=password=Y4nys7f11
```
or from a file change to use:
```
   --from-file=secret.properties
```

# RBAC
```bash
kubectl auth can-i delete nodes
```
Check whether the current user can execute the specified action.
If an Admin then you can also check whether a specified user can execute the specified action.


# Namespace-scoped vs. Cluster-scoped Resources

Namespace-scoped: ```kubectl api-resources --namespaced=true```

Cluster-scoped: ```kubectl api-resources --namespaced=false```
