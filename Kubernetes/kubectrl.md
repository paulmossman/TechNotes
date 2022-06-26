**<span style="font-size:3em;color:black">kubectl</span>**
***

# Reference

https://kubernetes.io/docs/reference/

# Top Level
Brief info:
```
kubectl get <all / rs / po / deploy / __>
```

Detailed info:
```
kubectl describe <all / rs / po / deploy / __>
```

Delete:
```
kubectl delete <rs / po / deploy / __> [Name]
```

Apply (or Create if it doesn't already exist) from JSON/YAML (Declarative):
```
kubectl apply -f ___.yaml
```

Expose a Pod ina Deployment via a port:
```
kubectl expose deployment <Pod> --port <Port>   /  OR --type=LoadBalancer
```
See: https://kubernetes.io/docs/tutorials/stateless-application/expose-external-ip-address/

Create a Pod:
```
kubectl run <Name> --image=<Image>
```

Explain YAML (including apiVersion):
```
kubectl explain <rs / po / deploy / deploy.spec / __> [--recursive]
```

List of resources that can be explained:
```
kubectl api-resources
```

Edit an existing (running) Resource:
```
kubectl edit <rs / po / deploy / __> [Name]
```

Taint a Node:
```
kubectl taint nodes node1 key1=value1:NoSchedule
```

Untaint a Node:
```
kubectl taint nodes node1 key1=value1:NoSchedule-
```

# Top Level Options

## Namespace
```
--namespace=___
```
If omitted, then "default" is assumed.

```
--all-namespaces
```

## Help
Very useful for seeign the options:
```
--help
```

# Resources
Get a list of all supported resources, including their short names:
```
kubectl api-resources
```

# dry-run --> YAML
```
kubectl <Options> --dry-run=client -o yaml > deployment.yaml
```

Example:
```
kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
```

# Using Edit, and then Replace
First use ```edit```, and change something that can't be changed.  Save fails, but creates a ```/tmp/kubectrl-edit-___.yaml```.

Then run:
```bash
kubectl replace --force -f /tmp/kubectrl-edit-___.yaml
```


# Frequent
```
kubectl get pods
kubectl get pods -o wide  # Include IP and Node
kubectl get pods \<Pod name\>  # Not much details
kubectl get pods \<Pod name\>  # Much detail
kubectl delete pod \<Pod name\>
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

# Create a Secret
```bash
kubectl create secret generic prod-db-secret --from-literal=username=produser --from-literal=password=Y4nys7f11
```
