resource "google_redis_instance" "cache" {
  name               = var.name
  tier               = var.tier
  memory_size_gb     = var.memory
  location_id        = var.location
  authorized_network = var.authorized_network
  redis_version      = var.redis_version
  display_name       = var.display_name
  reserved_ip_range  = var.reserved_ip_range
}
