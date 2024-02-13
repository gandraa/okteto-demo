# Okteto Demo 

*IMPORTANT:* The sample is runnable only in dedicated OpenShift environment.
All necessary images are already stored in OpenShift container registry..

The demo demonstrates how to configure and start okteto in an OpenShift test environment.

- Start okteto container in OpenShift cluster ;
- Debug application in localy;

Prerequisites
Before you begin this tutorial, you’ll need the following:

- kubectl (oc) installed and configured to communicate with your cluster.
- okteto CLI

Two docker images are mandatory and should be presented/downloaded in the container registry: 

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
6. Activate the development container: 
```shell
okteto up
```
7. After starting an okteto container, the user will be inside the container and will be able to start app directly from there (e.g. go run main.go)

Debug directly in Open Shift cluster

8. Cancel the execution of go run main.go from the development container shell by pressing ctrl + c. Rerun your application in debug mode:
```shell
dlv debug --headless --listen=:2345 --log --api-version=2
```
9. Open the Debug view in VS Code and run the Connect to okteto debug configuration 
10. Add a breakpoint on main.go, line 17. Call your application by executing from your local shell:  curl test-okteto-sandbox-cwis-cs.ocp-02.testdomain.com:8080 or refreshing web browser page https://test-okteto-sandbox-cwis.testdomain.com/
11. The execution will halt at the breakpoint. The user can then inspect the request, the available variables, etc…
12. Cancel the execution of debug mode from the development container shell by pressing ctrl + c
13. Finishing the test, terminate container and stop okteto using the command 
```shell
okteto down
```
