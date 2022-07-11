locals {
  kubeconfig      = "./config"
  create_command  = <<EOF
        helm repo add jetstack https://charts.jetstack.io &&
        helm repo update && 
        helm install cert-manager jetstack/cert-manager --namespace cert-manager \
        --create-namespace --set installCRDs=true \
        --kubeconfig  ${local.kubeconfig}
    EOF
  destroy_command = <<EOF
        helm uninstall cert-manager --kubeconfig  ${local.kubeconfig}
    EOF
}

resource "null_resource" "cert-manager" {
  provisioner "local-exec" {
    command = local.create_command
  }
}