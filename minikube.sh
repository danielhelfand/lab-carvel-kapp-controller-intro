# Set up minikube
# Requires minikube start --vm=true
minikube addons enable ingress

# Install edukates
kubectl apply -k "github.com/eduk8s/eduk8s?ref=master"
kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_DOMAIN=$(minikube ip).nip.io

# Install kapp-controller
kubectl apply -f https://raw.githubusercontent.com/vmware-tanzu/carvel-kapp-controller/dev-packaging/alpha-releases/v0.18.0-alpha.5.yml
