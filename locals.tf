locals {
  k8s_namespace = chomp(file("/var/run/secrets/kubernetes.io/serviceaccount/namespace"))
}