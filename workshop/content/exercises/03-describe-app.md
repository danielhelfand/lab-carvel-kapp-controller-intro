Congratulations on deploying your first App CR! In this section, 
lets take a deeper look at what was created in your namespace as 
a result of creating this App.

As we mentioned in the previous section, the git url in the fetch 
portion of the App spec contained manifests for a Kubernetes deployment 
and service. Let's verify that both now exist in your namespace.

Verify that a deployment named simple-app exists in your namespace:

```execute-1
kubectl get deployments
```

Verify that a service named simple-app exists in your namespace:

```execute-1
kubectl get services
```

Grabbing the cluster ip address of the service, you can verify that the application 
deployed is running successfully:

```execute-1
SIMPLE_APP_CLUSTER_IP=$(k get services/simple-app -o=jsonpath={.spec.clusterIP})
```

Now go ahead and run the curl command below to ping the application to get a response back:

```execute-1
curl SIMPLE_APP_CLUSTER_IP
```

You should get back a response of `<h1>Hello stranger!</h1>` confirming the App CR deployed 
this application to your cluster.