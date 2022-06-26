**<span style="font-size:3em;color:black">Kubernetes General</span>**
***

# Pod

A Kubernetes encapsulation of one or more Containers.  (Though in practice it's almost always only one Container.)

# Replication Controller

Keeps right # of Pods running.  Load Balancing and Scaling.
Older.  Being replaced by ReplicaSet.

# Services

Allows communictions to other components, e.g user endpoints, other pods, DBs.  Types:
1. NodePort
1. ClusterIP
1. LoadBalancer

# Secrets
Not actually very secret, just base64 encoded, so easy to decode.  Some special treatment (only given to pods that request them, not written to disk.)

For things that are really secret use Helm Secrets or HashiCorp Vault.
