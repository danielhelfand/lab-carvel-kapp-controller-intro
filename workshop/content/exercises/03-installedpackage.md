Now that you have Packages available on your cluster, you will be able
to install a Package (i.e. deploy the software to your cluster). 

To do this with kapp-controller, you will need to create an `InstalledPackage`. 
Let's take a look at an InstalledPackage definition:

```yaml
apiVersion: install.package.carvel.dev/v1alpha1
kind: InstalledPackage
metadata:
  name: simple-app
spec:
  serviceAccountName: simple-app-sa
  packageRef:
    publicName: simple-app.corp.com
    version: 1.0.0
```

The InstalledPackage resource above tells kapp-controller which Package you 
would like to be installed on your cluster. In the previous section, you were 
able to look at a Package named `simple-app.corp.com.1.0.0`. 

The name of this Package is a combination of the `publicName` and `version` 
seen above under the `packageRef` property of the InstalledPackage, which is 
a recommended naming convention for Packages. Each Package also has a publicName 
and a version, so the InstalledPackage knows exactly which Package version a user 
wants to install.

Before you can create this InstalledPackage, one thing you will need to setup is 
some appropriate RBAC for the InstalledPackage. This tells your Kubernetes cluster 
that this InstalledPackage can create, update, and delete certain resources. 

Since you are recreating the sample app from the beginning of this tutorial, you will 
need to create a `ServiceAccount` that has permissions to create a Kubernetes Deployment 
and Service:

```execute-1
kapp deploy -a rbac -f /home/eduk8s/kapp-controller/rbac.yml -y
```

You just created a ServiceAccount named simple-app-sa with the permissions needed to 
create a Service/Deployment. Your InstalledPackage will make use of this ServiceAccount 
via the `serviceAccountName` property. 

You can now go ahead and create the InstalledPackage:

```execute-1
kapp deploy -a simple-app -f /home/eduk8s/kapp-controller/installedpackage.yml -y
```

Once the command above is finished, we can follow the same steps from before to verify 
a successful deployment:

{% raw %}
```execute-1
SIMPLE_APP_CLUSTER_IP=`kubectl get svc/simple-app -o template --template '{{.spec.clusterIP}}'`
```
{% endraw %}

Ping the service to get back a response:

```execute-1
curl $SIMPLE_APP_CLUSTER_IP
```

You should see the same response from the application you deployed earlier.

In the next section, you will learn about what happened once the InstalledPackage 
was created to get this sample running.


```execute-1
clear
```

Click `App CR` to continue.