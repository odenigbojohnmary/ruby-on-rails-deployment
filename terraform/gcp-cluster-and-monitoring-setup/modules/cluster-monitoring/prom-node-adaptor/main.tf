locals {
  kubeconfig      = "./config"
  create_command  = <<EOF
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts &&
        helm repo update && 
        helm upgrade --namespace default --atomic \
        --install --wait prometheus-adapter prometheus-community/prometheus-adapter --kubeconfig  ${local.kubeconfig}
    EOF
  destroy_command = <<EOF
        helm uninstall prometheus-adapter --kubeconfig  ${local.kubeconfig}
    EOF
}

resource "null_resource" "prometheus-adapter" {
  provisioner "local-exec" {
    command = local.create_command
  }
}