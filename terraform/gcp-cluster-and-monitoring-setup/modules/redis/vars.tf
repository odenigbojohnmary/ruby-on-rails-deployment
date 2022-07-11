variable "name" {
  description = "name of redis server"
  type        = string
}
variable "tier" {
  description = "tier of redis server"
  type        = string
}
variable "memory" {
  description = "memory of redis server"
  type        = number
}
variable "location" {
  description = "location of redis server"
  type        = string
}
# variable "alternative_location_id" {
#   description = "alternative_location_id of redis server"
#   type        = string
# }
variable "redis_version" {
  description = "redis_version of redis server"
  type        = string
}
variable "display_name" {
  description = "display_name of redis server"
  type        = string
}
variable "reserved_ip_range" {
  description = "reserved_ip_range of redis server"
  type        = string
}
variable "authorized_network" {
  description = "reserved_ip_range of redis server"
  type        = string
}