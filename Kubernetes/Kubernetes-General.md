# Kubernetes General

## Pod

A Kubernetes encapsulation of one or more Containers.  (Though in practice it's almost always only one Container.)

## Replication Controller

Keeps right # of Pods running.  Load Balancing and Scaling.
Older.  Being replaced by ReplicaSet.

## Services

Allows communictions to other components, e.g user endpoints, other pods, DBs.  Types:
1. NodePort
1. ClusterIP
1. LoadBalancer