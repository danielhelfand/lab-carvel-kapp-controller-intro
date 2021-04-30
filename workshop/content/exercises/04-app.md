In the previous section, you created an InstalledPackage that 
created a particular version of an application in your namespace.

Run the following command to verify that the InstalledPackage exists:

```execute-1
kubectl get installedpackage/simple-app
```

Let's take a further look at the InstalledPackage by running a 
kubectl describe on it:

```execute-1
kubectl describe installedpackage/simple-app
```

You will notice there is not a lot of information in the status 
of the InstalledPackage. The status for an InstalledPackage only 
ever shows if the InstalledPackage succeeded or what error occurred 
if it fails. In this particular case, you can see from the `Friendly 
Description` property that the `Reconcile succeeded`.

You might be wondering where more information about the deployment 
status of the InstalledPackage are stored. kapp-controller has a 
CRD called an App, which carries out the process of fetching, templating, 
deploying, syncing, and providing status updates of resources deployed 
via an InstalledPackage.

The name of the App CR will always correspond to the name of the InstalledPackage. 
Let's go ahead and take a look at the App for the InstalledPackage you just 
created:

```execute-1
kubectl get apps/simple-app
```

The App CR serves as the continuous delivery mechanism for kapp-controller. It uses 
the information specified by a Package CR to fetch, template, and deploy an application 
as specified by the Package. 

InstalledPackages help to abstract how a Packages/Apps work in order to help you 
simply install software to your cluster.

Once an App is created, it also regularly syncs with its underlying fetch source (i.e. 
an imgpkg bundle in this case) to make sure the latest updates are always deployed in 
the way that is specified by the Package definition. 

By default, an App will sync every 30 seconds but this property can be configured to sync 
for a longer period of time by changing the App's `spec.syncPeriod` property.

One of the advantages of this sync behavior is not needing to update anything on your 
cluster if you make changes to an external dependency (e.g. an imgpkg bundle, OCI image, 
or git repository).

Now that you have learned more about how kapp-controller handles aspects of continuous delivery 
through the App CR, let's take a look at how you can upgrade your Package version in the next 
section.

```execute-1
clear
```

Click `Upgrade Package Version` to continue.
