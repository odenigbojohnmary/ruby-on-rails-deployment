resource "kubernetes_config_map" "configmap" {
  metadata {
    name      = "grafana-datasources"
    namespace = var.monitoring_name_space
    labels = {
      name = "grafana-datasources"
    }
  }
  data = {
    "prometheus.yaml" = "${file("${path.module}/prometheus.yml")}"
  }

}

locals {
  kubeconfig      = "./config"
  prometheus-config ="${path.module}/prometheus-saml.yaml"
  create_command  = <<EOF
        kubectl apply -f ${local.prometheus-config} --kubeconfig ${local.kubeconfig}
    EOF
  destroy_command = <<EOF
        kubectl delete -f ${local.prometheus-config} --kubeconfig ${local.kubeconfig}
    EOF
}

resource "null_resource" "prometheus-samls" {
  provisioner "local-exec" {
    command = local.create_command
  }
}