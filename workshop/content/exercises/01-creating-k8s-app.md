Before you learn about kapp-controller, let's start by deploying and 
running some software on Kubernetes to learn about some of the 
motivations behind Carvel tools and kapp-controller.

Kubernetes resources are typically defined as YAML configuration and 
may also rely on container images to host and run an application. 

Lets take a look at a sample application's configuration to be hosted 
on Kubernetes:

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: simple-app
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    simple-app: ""
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: simple-app
spec:
  selector:
    matchLabels:
      simple-app: ""
  template:
    metadata:
      labels:
        simple-app: ""
    spec:
      containers:
      - name: simple-app
        image: docker.io/dkalinin/k8s-simple-app@sha256:4c8b96d4fffdfae29258d94a22ae4ad1fe36139d47288b8960d9958d1e63a9d0
        env:
        - name: HELLO_MSG
          value: stranger
```

All of the YAML above and the various properties defined within it are needed 
to deploy a hello world app on Kubernetes. You will need a `Deployment` with 
a container image containing the application's source and runtime instructions 
and a `Service` to expose the application.

While this sample app configuration isn't overwhelming, software that you will 
rely on every day that runs on your Kubernetes cluster will require many more 
resources defined in YAML, not just one but several container images, and you 
will need to be able to configure certain aspects of the software you are running.

Let's also take a look at the process for deploying these resources to your cluster. 
Go ahead and run the command below:

```execute-1
kubectl apply -f /home/eduk8s/kapp-controller/simple-app.yml
```

You should see a confirmation message from kubectl showing that the resources were 
created:

```
service/simple-app created
deployment.apps/simple-app created
```

What can be a bit misleading about this message though is that the Deployment you deployed 
is not actually running once kubectl finishes deploying this application. The Deployment will 
still take some time to start running and it may not even deploy successfully despite the 
confirmation message from kubectl about its creation.

In this case, the application should be deployed successfully and we can confirm this by pinging 
the sample app to see if it's running. Let's grab the cluster IP address to access the application:

{% raw %}
```execute-1
SIMPLE_APP_CLUSTER_IP=`kubectl get svc/simple-app -o template --template '{{.spec.clusterIP}}'`
```
{% endraw %}

Now you can ping the service to get back a response:

```execute-1
curl $SIMPLE_APP_CLUSTER_IP
```

Now that we have gone through the process of successfully deploying this application, lets also 
clean everything up now that we are done. 

Delete the Deployment:

```execute-1
kubectl delete deployments/simple-app
```

Delete the Service:

```execute-1
kubectl delete service/simple-app
```

So what are some things about this process of deploying software to Kubernetes that could be improved? 

What if you didn't have to work directly with the underlying YAML configuration and containers 
for the application? 

What if you didn't have to think about where this YAML/containers are located? 

What about having a way to follow the deployment process and know more immediately whether resources are 
deployed successfully or encountered failures?

What about having to know to remove each unique resource deployed as part of the application?

What about versioning this application?

These are some of the challenges that kapp-controller addresses and that you 
will learn about in the next sections of this tutorial.

Clear your terminal before continuing:

```execute-1
clear
```
