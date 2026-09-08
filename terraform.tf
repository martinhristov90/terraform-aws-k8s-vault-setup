  terraform {
    backend "kubernetes" {
      secret_suffix     = "tf-provision-state"
      namespace         = "vault"
      in_cluster_config = true
    }
  }
