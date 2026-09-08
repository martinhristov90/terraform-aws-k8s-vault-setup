  terraform {
    backend "kubernetes" {
      secret_suffix     = "tf-provision-state"
      in_cluster_config = true
      # namespace is passed via -backend-config at init time from the pod's service account
    }
  }
