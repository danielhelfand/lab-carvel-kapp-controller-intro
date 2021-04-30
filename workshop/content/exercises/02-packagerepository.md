Now that you have deployed an application to Kubernetes and we have 
gone over some of the challenges, let's see how kapp-controller aims 
to address some of these challenges.

As a Kubernetes package manager, kapp-controller is able to make software 
packages available on your cluster through a resource called a `Package`. 
A Package is an encapsulation of both the configuration, images, and 
process needed to deploy software to your Kubernetes cluster.

One way of making these kapp-controller Packages available on your cluster 
is through what is called a `PackageRepository`, which is a collection of 
Packages.

Let's take a look at the configuration for creating a PackageRepository:

```yaml
---
apiVersion: install.package.carvel.dev/v1alpha1
kind: PackageRepository
metadata:
  name: simple-package-repository
spec:
  fetch:
    imgpkgBundle:
      image: k8slt/kctrl-pkg-repo:v2.0.0
```

The PackageRepository above has under the `fetch` portion of its `spec` a property 
called `imgpkgBundle`, which is an OCI image that contains both configuration and 
associated container images. For this PackageRepository, the configuration included 
in this image (`k8slt/corp-com-pkg-repo:1.0.0`) are Package resources, which also 
can be linked to OCI images containing configuration and images.

Let's go ahead and create the PackageRepository above to provide some clarity on the 
Package/PackageRepository concepts:

```execute-2
kapp deploy -a repo -f /home/eduk8s/kapp-controller/packagerepo.yml -y
```

The command you just ran uses a Kubernetes deployment tool called `kapp`, which kapp-controller 
itself uses to deploy Kubernetes resources. Once the kapp command finishes running, you can now 
view what Packages this PackageRepository has made available on your cluster:

```execute-1
kubectl get packages
```

The Packages you just installed on your cluster are all different versions of the sample application 
you just deployed in the previous section. 

Let's take a look at one of these Packages:

```execute-1
kubectl get packages/simple-app.corp.com.1.0.0 -o yaml
```

The interesting part of a Package is its `spec`, which contains information about fetching, templating, 
and deploying software to Kubernetes.

```yaml
fetch:
- imgpkgBundle:
    image: index.docker.io/k8slt/kctrl-example-pkg@sha256:95241524c255f8d811152e09a3ec3de71cb00385c6c463228fb448ccffdf1628
```

The fetching portion of the spec above refers to gathering the configuration and associated images a piece 
of software has defined for deploying to Kuberenetes. In this case of this Package, the fetch source is an 
imgpkgBundle, which is the same source the PackageRepository uses. This source can come from a variety 
of sources including git, http, and also helm charts in addition to OCI image registries. 


```yaml
template:
- ytt:
    paths:
    - config.yml
    - values.yml
- kbld:
    paths:
    - '-'
    - .imgpkg/images.yml
```

The templating portion of the spec above shows how kapp-controller uses tools from the Carvel suite (i.e. `ytt` and `kbld`) 
to prepare the YAML configuration for this software package before it is deployed to your cluster. This allows users to provide 
inputs to the YAML configuration as opposed to hard coding the values into the YAML files. 

```yaml
deploy:
- kapp: {}
```

The deploy section of the spec states how/where to deploy the resources this Package creates. In this case, 
this Package will deploy your software to the namespace you are currently working in since no namespace option 
was provided. You will notice that the `deploy` portion of the spec uses `kapp` the same tool you just used to 
deploy the PackageRepository.

In the next section, you will deploy this Package to your namespace and learn about the package consumer workflows 
kapp-controller offers.

Clear both of your terminals before continuing:

```execute-1
clear
```

```execute-2
clear
```

Click `Installing a Package` to continue.