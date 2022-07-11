locals {
  kubeconfig      = "./config"
  create_command  = <<EOF
        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx &&
        helm repo update && 
        helm install ingress-controller ingress-nginx/ingress-nginx \
        --set controller.service.loadBalancerIP=34.105.186.62 \
        --kubeconfig  ${local.kubeconfig}
    EOF
  destroy_command = <<EOF
        helm uninstall ingress-controller --kubeconfig  ${local.kubeconfig}
    EOF
}

resource "null_resource" "nginx-ingress" {
  provisioner "local-exec" {
    command = local.create_command
  }
}