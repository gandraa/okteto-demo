# Okteto Demo 

*IMPORTANT:* The sample is runnable only in OpenShift IKEA network and has to be used in test environment (https://ocm-02.ikeadt.com:8443/).
All necessary images are already stored in OpenShift container registry..

The demo demonstrates how to configure and start okteto in OpenShift IKEA test environment.

- Start okteto container in OpenShift cluster ;
- Debug application in localy;

Prerequisites
Before you begin this tutorial, you’ll need the following:

- kubectl (oc) installed and configured to communicate with your cluster.
- okteto CLI

Due to blacklisting dockerhub.io in Open Shift cluster, two docker images are mandatory and should be imported in the local registry: 

- okteto/golang
- okteto/bin

1. Select appropriate Kubernetes workspace (e.g. kubectl config use-context sandbox-cwis-cs). The context is defined in Kubernetes config file
2. Deploy application in Open Shift cluster using k8s deployment configuration
```shell
oc apply -f k8s
```
3. In OpenShift Route will created the service endpoint. Try to open it in browser to be sure that the app is up and running
4. Create okteto manifest inside project running okteto init. The okteto init command will scan the available deployments in Kubernetes namespace, and ask to pick one. Select the  deployment. 
5. The okteto init command creates the okteto.yml file. The file should be adjusted according the Open Shift configuration 

```yaml
name: test-okteto
image: docker-registry.default.svc:5000/sandbox-cwis-cs/golang:1
workdir: /app
command: ["bash"]
environment:
  #https://github.com/openshift/release/issues/9748
  - GOCACHE=/tmp/
securityContext:  
  runAsUser: 1002340000
initContainer:
  image: docker-registry.default.svc:5000/sandbox-cwis-cs/okteto:1.2.23
  resources:
    requests:
      cpu: 100m
      memory: 30Mi
    limits:
      cpu: 200m
      memory: 30Mi
forward:
  - 8080:8080
  - 2345:2345
```
6. Activate the development container: okteto up
7. After starting an okteto container, the user will be inside the container and will be able to start app directly from there (e.g. go run main.go)
8. Finishing the test, terminate container and stop okteto using the command okteto down 


