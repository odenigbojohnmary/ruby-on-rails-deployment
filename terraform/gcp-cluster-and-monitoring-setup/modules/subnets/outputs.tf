output "subnets" {
  value       = google_compute_subnetwork.subnetwork
  description = "The created subnet resources"
}

output "subnets_names" {
  value       = [for network in google_compute_subnetwork.subnetwork : network.name]
  description = "The names of the subnets being created"
}