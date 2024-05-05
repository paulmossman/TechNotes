**<span style="font-size:3em;color:black">Kubernetes Sample YAML</span>**
***

Online reference documentation: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#api-groups

Examples: https://kubernetes.io/docs/tasks/ and https://kubernetes.io/docs/concepts/.

Useful: ```kubectl explain RESOURCE```, for example:
```
$ kubectl explain pod.spec.affinity
KIND:       Pod
VERSION:    v1

FIELD: affinity <Affinity>

DESCRIPTION:
    If specified, the pod's scheduling constraints
    Affinity is a group of affinity scheduling rules.

FIELDS:
  nodeAffinity  <NodeAffinity>
    Describes node affinity scheduling rules for the pod.

  podAffinity   <PodAffinity>
    Describes pod affinity scheduling rules (e.g. co-locate this pod in the same
    node, zone, etc. as some other pod(s)).

  podAntiAffinity       <PodAntiAffinity>
    Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in
    the same node, zone, etc. as some other pod(s)).
```

# Secrets

## Access via Environment Variable - into a Container

In the ```spec:``` / ```containers:``` section...

[Reference](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data)

### All Keys
```
  envFrom:
  - secretRef:
    name: <Secret name>
```

### One Key
```
  env:
  - name: <Env Var name>
    valueFrom:
      secretKeyRef:
        name: <Secret name>
        key: <Key name>
```

## Access via Volume - into a Pod
(Available to all Containers in the Pod.)

In the ```spec:``` section...

```
  volumes:
    - name: <Volume name>
      secret:
        secretName: <Secret name>
```

The Volume must still be mounted in Container(s).
 
# Node Affinity

For a Pod, evaluate Labels on the Nodes...

Example:
```
spec:
   affinity:
      nodeAffinity:
         requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
               - key: colour
               operator: In
               values:
               - red
               - yellow
```

Operators:
- In
- NotIn
- Exists
- DoesNotExist
- Gt (integer only)
- Lt (integer only)

References:
- https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#operators
- ```kubectl explain pod.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms.matchExpressions```

To achieve "Equals", the "values:" should simply be a list of one.

Types:
1. requiredDuringSchedulingIgnoredDuringExecution
2. preferredDuringSchedulingIgnoredDuringExecution
(More are planned.  i.e. "during execution".)