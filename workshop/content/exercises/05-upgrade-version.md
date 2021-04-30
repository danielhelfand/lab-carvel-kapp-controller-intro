In addition to installation and continuous delivery, kapp-controller also 
helps you appropriately version software installed on your cluster.

As mentioned previously, you have several versions of the Package you installed 
on your cluster available. Take a look to see what is available:

```execute-1
kubectl get packages
```

You should see a Package named `simple-app.corp.com.2.0.0`. This represents version 
2.0.0 of the Package you currently have installed.

You can see the version of the current Package installed by looking at the `Package Version` 
column in the output of the command below:

```execute-1
kubectl get installedpackage/simple-app
```

To upgrade this InstalledPackage to version 2.0.0, all you need to do is change the 
`spec.packageRef.version` property to the version you want to upgrade to:

```yaml
apiVersion: install.package.carvel.dev/v1alpha1
kind: InstalledPackage
metadata:
  name: simple-app
spec:
  serviceAccountName: simple-app-sa
  packageRef:
    publicName: simple-app.corp.com
    version: 2.0.0
```

After editing changing the version property in the YAML, you can go ahead and 
redeploy the InstalledPackage CR, but first let's briefly discuss what will 
change from version 1.0.0 to 2.0.0.

Let's watch the deployment for the simple-app that is currently deployed for 
simple-app version 1.0.0 in the bottom of the two terminals:

```execute-2
watch kubectl get deployments/simple-app
```

Under the `READY` column, you will notice the pod count for this deployment is 
currently `1/1`. In version 2.0.0 of simple-app, this deployment will instead 
have 3 pods deployed. So we can expect this column to show `3/3` to denote three 
pods are running after the upgrade takes place.

Go ahead redeploy the InstalledPackage and watch for the changes in your bottom
terminal:

```execute-1
kapp deploy -a simple-app -f /home/eduk8s/kapp-controller/installedpackage-2.0.0.yml -y
```

After you see the pod count increase, you can also verify that your InstalledPackage 
version has also changed by running the command below:

```execute-1
kubectl get installedpackage/simple-app
```

The `Package Version` column should now show 2.0.0.

You can stop the watch on the deployment pod count in the lower terminal:

```execute-2
<ctrl+c>
```

In the next section, you will uninstall the Package you have installed. 

Clear both terminals before continuing:

```execute-1
clear
```

```execute-2
clear
```

Click `Uninstall Package` to continue.
