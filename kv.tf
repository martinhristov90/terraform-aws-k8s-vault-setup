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
