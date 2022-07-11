
variable "project_id" {
  description = "Google Cloud Project ID being monitored"
  type        = string
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog APP key"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "Datadog APP key"
  type        = string
  sensitive   = true
}

