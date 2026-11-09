#To access the metrics endpoint the Kube auth will be utilized
#THIS IS CURRENTLY NOT USED!!!
#Creating a policy to read metrics endpoint
resource "vault_policy" "prometheus_metrics_policy" {
  name   = "prometheus_metrics_policy"
  policy = <<EOT
path "sys/metrics" {
  capabilities = ["read"]
}
EOT
}

#Enabling Kube auth at default path
resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

#Configuring Kube auth
resource "vault_kubernetes_auth_backend_config" "example" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = "https://kubernetes.default.svc.cluster.local:443"
  disable_iss_validation = "true"
}

#Configuring Kube role
resource "vault_kubernetes_auth_backend_role" "example" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "prometheus-role"
  bound_service_account_names      = ["prometheus"]
  bound_service_account_namespaces = ["*"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.prometheus_metrics_policy.name]
}

