You have successfully installed an application in your namespace 
and also upgraded the application version using kapp-controller. 

Now let's see how kapp-controller handles the uninstall process 
to make cleaning up unused resources on your cluster an easy process.

To uninstall a Package, you can simply delete the InstalledPackage you 
created and all associated resources will be cleaned up. To show this 
in action, watch the resources currently deployed in your namespace in 
the bottom terminal:

```execute-2
watch kubectl get all
```

Now go ahead and delete the InstalledPackage and after watch as resources 
are removed:

```execute-1
kapp delete -a simple-app -y
```

Once the command above has finished running, you should see that all 
resources are being removed from your namespace.

You can also verify that the InstalledPackage/App both no longer exist:

```execute-1
kubectl get installedpackages
```

```execute-1
kubectl get apps
```

You should see that both kubectl commands return no resources, which confirms the 
successful removal of the application you deployed.


You can stop the watch in the second terminal one you see all resources have been 
deleted:

```execute-2
<ctrl+c>
```

Click `Workshop Summary` for some additional resources on kapp-controller and Carvel 
before finishing the tutorial.
