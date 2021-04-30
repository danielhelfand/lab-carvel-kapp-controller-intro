# LAB - An Introduction to kapp-controller

A tutorial on learning the fundamentals of Kubernetes package management with kapp-controller.

# Run This Tutorial

As of now, this tutorial has only been run on `minikube`, so it is recommended to use `minikube` 
to host the tutorial.

1. `minikube start --vm=true` (The workshop requires the minikube ingress addon so `--vm=true` is [required for Mac users](https://github.com/kubernetes/minikube/issues/7332))
2. `sh minikube.sh` (Once minikube is running, run the minikube.sh script to install everything needed to support the tutorial)
3. `kubectl apply -k https://github.com/danielhelfand/lab-carvel-kapp-controller-intro` (Installs the tutorial)
4. `watch kubectl get pods -n lab-carvel-kapp-controller-intro-w01` (Wait for all pods to be running in the `lab-carvel-kapp-controller-intro-w01` namespace)
5. `kubectl get trainingportals` (Once the pod is running in `lab-carvel-kapp-controller-intro-w01`, run the command and click on the url under the `URL` column)
6. Click `Start workshop` in your browser to begin tutorial
