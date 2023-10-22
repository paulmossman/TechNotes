**<span style="font-size:3em;color:black">Helm</span>**
***

# Create a simple Deployment with a NodePort Service
```
helm create <Chart Name>
```
This creates a "\<Chart Name\>" directory.

By default the ```nginx``` Docker image is used.  Change it via the values.yaml file's ```image.repository``` value.

By default a ClusterIP service will be created, but a NodePort is probably more useful.  Change the values.yaml file's ```service.type``` value to "NodePort".  The allocated NodePort number is random by default.  The ```helm install``` output will show you how to discover it.  (But don't trust the NODE_IP value.)  To specify the NodePort number:
- In the values.yaml file add ```nodePort: <port #>``` under ```service:```.
- In the templates/service.yaml file add ```nodePort: {{ .Values.service.nodePort }}``` to the ```spec.type.ports:``` section's ```port``` entry.

Start:
```bash
helm install <Deployment Name> <Chart Name>/ --values <Chart Name>/values.yaml
```
 
Describe the Pod:
```bash
kubectl describe `kubectl get all | grep "pod/<Deployment Name>" | cut -f1 -d" "`
```

Get the Pod's YAML:
```bash
kubectl get pod `kubectl get all | grep "pod/<Deployment Name>" | cut -f1 -d" " | cut -f2 -d"/"` -o yaml
```

Watch the Pod's logs:
```bash
kubectl logs -f deployment.apps/<Deployment Name>
```

Stop:
```bash
helm uninstall <Deployment Name>
```


