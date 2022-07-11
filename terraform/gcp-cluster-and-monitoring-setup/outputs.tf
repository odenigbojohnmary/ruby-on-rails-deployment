output "network" {
  value       = module.vpc
  description = "The created network"
}

output "subnets" {
  value       = module.subnets.subnets
  description = "A map with keys of form subnet_region/subnet_name and values being the outputs of the google_compute_subnetwork resources used to create corresponding subnets."
}

output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = module.vpc.project_id
  description = "VPC project id"
}

output "subnets_names" {
  value       = [for network in module.subnets.subnets : network.name]
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = [for network in module.subnets.subnets : network.ip_cidr_range]
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = [for network in module.subnets.subnets : network.self_link]
  description = "The self-links of subnets being created"
}

output "subnets_regions" {
  value       = [for network in module.subnets.subnets : network.region]
  description = "The region where the subnets will be created"
}

output "subnets_private_access" {
  value       = [for network in module.subnets.subnets : network.private_ip_google_access]
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_flow_logs" {
  value       = [for network in module.subnets.subnets : length(network.log_config) != 0 ? true : false]
  description = "Whether the subnets will have VPC flow logs enabled"
}

output "subnets_secondary_ranges" {
  value       = [for network in module.subnets.subnets : network.secondary_ip_range]
  description = "The secondary ranges associated with these subnets"
}

output "route_names" {
  value       = [for route in module.routes.routes : route.name]
  description = "The route names associated with this VPC"
}

# output "name" {
#   description = "Cluster name"
#   value       = "${module.gke.name}"
#   depends_on = [ "${module.subnets.subnets_names}" ]
# }


output "grafana_dashboard_authentication" {
  description = "grafana default authentication"
  value       = "admin:admin"
}
output "grafana_dashboard_node_exporter_1" {
  description = "node exporter dashboard 1"
  value       = "1860"
}
output "grafana_dashboard_node_exporter_2" {
  description = "node exporter dashboard 2"
  value       = "11074"
}
output "grafana_dashboard_deployment" {
  description = "deployment dashboard"
  value       = "8588"
}

output "alertmanager_node_port" {
  description = "alertmanager node port"
  value       = var.alertmanager_node_port
}

output "grafana_node_port" {
  description = "grafana node port"
  value       = var.alertmanager_node_port
}

output "prometheus_node_port" {
  description = "prometheus node port"
  value       = var.alertmanager_node_port
}