**<span style="font-size:3em;color:black">Kubernetes Distributions</span>**
***

# Minikube

A local Kubernetes cluster on macOS, Linux, and Windows.  Deploy as a VM, a container, or on bare-metal.  (Source: https://minikube.sigs.k8s.io/docs/)  Into Docker (via "driver") is a popular option. 

Start on Mac in Docker, with Ingress:
```bash
minikube start --memory=7841 --cpus=3 --kubernetes-version=v1.20.2 --driver=docker
minikube addons enable ingress
```

# k3s

Lightweight (minimal) Kubernetes: https://k3s.io/

## k3d

A lightweight wrapper to run k3s in Docker: https://k3d.io/
