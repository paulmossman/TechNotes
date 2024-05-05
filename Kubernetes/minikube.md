**<span style="font-size:3em;color:black">Minikube</span>**
***

Start on Mac, with Ingress:
```bash
minikube start --memory=7841 --cpus=3 --kubernetes-version=v1.20.2 --driver=docker
minikube addons enable ingress
```