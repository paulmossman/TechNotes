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

# Upgrade

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

# Backup & Restore (if you manager yoru Kubernetes service)
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

Note, required stcdctl options:
```bash
--cacert
--cert
--endpoints=[127.0.0.1:2379]
--key
```