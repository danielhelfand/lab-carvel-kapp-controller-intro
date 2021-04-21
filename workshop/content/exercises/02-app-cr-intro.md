Let's start by introducing the kapp-controller concept of an App.

#### Apps

The App CRD specifies how to fetch, template, and deploy an application to Kubernetes. It also 
tracks the status of whether or not resources are successfully deployed to a cluster.

Fetching referes to gathering Kubernetes configuration that defines the resources needed 
to run an application on a cluster. 

Templating is the process of making the fetched configuration files dynamic by allowing 
aspects of the configuration to be customized to a user's needs.

Deploying refers to creating, updating, or deleting resources specified by an App's templated 
configuration. 

Go ahead and check that the cluster you are using has resources called Apps:

```execute-1
kubectl api-resources --api-group=kappctrl.k14s.io
```

You should see the command above returns some details about the App CR, confirming the resource 
is available on the cluster

Lets walk through a simple App definition shown below:

```yaml
apiVersion: kappctrl.k14s.io/v1alpha1
kind: App
metadata:
  name: simple-app
spec:
  serviceAccountName: simple-app-sa
  fetch:
  - git:
      url: https://github.com/k14s/k8s-simple-app-example
      ref: origin/develop
      subPath: config-step-2-template
  template:
  - ytt: {}
  deploy:
  - kapp:
      intoNs: %session_namespace%
```

The App CR above is named `simple-app`. 

The interesting parts of the App spec are the `fetch`, `template`, and `deploy` 
properties of the App. 

For `simple-app`, this App CR wil fetch Kubernetes manifests from a GitHub repository 
shown in the `url` under the fetch property. The `ref` property states we want to fetch 
the develop branch of this git repository. The `subPath` property denotes that the App 
CR should only work with manifests in the subdirectory of the git repository named 
`config-step-2-template`.

After fetching the Kubernetes manifests located in the directory `config-step-2-template`, we 
specify that we want to template these Kubernetes manifests using [`ytt`](https://carvel.dev/ytt/). 
In this case, we do not want to pass any additional arguments to `ytt` in the templating phase 
since we just want to template all YAML retrieved during the fetch process.

The last portion of the App spec is the `deploy` property, which tells kapp-controller where and 
how to deploy the resources specified in the templated manifests. The tool used to deploy these resources 
by kapp-controller is [`kapp`](https://carvel.dev/kapp/). In this case, one property is filled out 
for deploy named `intoNs`, which allows you to pick which namespace on the cluster to deploy to. The 
namespace you are set up to use is named %session_namespace%, so we will deploy the App CR to this namespace.

Let's go ahead and actually create this App in your namespace. First, you will need to set up appropriate 
RBAC for the App CR so the App can create resources specified in the manifests available at 
`https://github.com/k14s/k8s-simple-app-example/config-step-2-template`. 

```execute-1
kapp deploy -a rbac -f /home/eduk8s/appcr/rbac.yml -y
```

The command you just ran created a serviceaccount, role, and rolebinding that will allow the App CR to create 
configmaps, services, and deployments. These are the resources defined in the configuration of the fetch step.

The App CR makes use of this serviceaccount created named `simple-app-sa` via its `serviceAccountName` property. 
The serviceaccount has the role bound to it, allowing the App to create what is specified in the role's permissions.

Now you should be able to create the App CR:

```execute-1
kapp deploy -a simple-app -f /home/eduk8s/appcr/simple-app-1.yaml -y
```

You can now run the command below to verify a successful deployment of the App:

```execute-1
kubectl get apps/simple-app
```

You should see under the `Description` column from kubectl that the App has a `ReconcileSucceeded`
status. This confirms a successful deployment.

In the next section, let's dig deeper into what happened when the App CR was created.