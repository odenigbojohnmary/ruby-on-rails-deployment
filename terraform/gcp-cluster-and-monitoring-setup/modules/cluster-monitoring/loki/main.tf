locals {
  kubeconfig      = "./config"
  create_command  = <<EOF
        helm repo update && 
        helm upgrade --install loki grafana/loki-stack --namespace=default --kubeconfig  ${local.kubeconfig}
    EOF
  destroy_command = <<EOF
        helm uninstall loki --kubeconfig  ${local.kubeconfig}
    EOF
}

resource "null_resource" "loki-logs" {
  provisioner "local-exec" {
    command = local.create_command
  }
}