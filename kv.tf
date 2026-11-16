# Enable KV v2 secrets engine at path "secret"
resource "vault_mount" "kv" {
  path = "secret"
  type = "kv-v2"
}

# Write a KV secret at path "sample" with foo=bar
resource "vault_kv_secret_v2" "sample" {
  mount = vault_mount.kv.path
  name  = "sample"

  data_json = jsonencode({
    foo = "bar"
  })
}


# Policy allowing access to KV sample secret for the demo_sa_role role
resource "vault_policy" "kv_secrets" {
  name = "kv-secrets"

  policy = <<EOT
path "${vault_mount.kv.path}/data/${vault_kv_secret_v2.sample.name}" {
  capabilities = ["update","create","read"]
}
EOT
}