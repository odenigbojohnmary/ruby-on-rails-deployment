# Google Service Account Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "this" {
  project      = var.project_id
  account_id   = "datadog"
  display_name = "Service Account for Datadog"
}

# Project Service Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service

resource "google_project_service" "this" {
  for_each = toset(
    [
      "cloudbilling.googleapis.com",
      "monitoring.googleapis.com",
      "compute.googleapis.com",
      "pubsub.googleapis.com",
      "cloudasset.googleapis.com",
      "container.googleapis.com"
    ]
  )

  project = var.project_id
  service = each.key

  disable_on_destroy = false
}

# Google Project IAM Member Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member

resource "google_project_iam_member" "this" {
  provider = google
  for_each = toset([
    "roles/cloudasset.viewer",
    "roles/compute.viewer",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.this.email}"
}

# Google Service Account Key Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key

resource "google_service_account_key" "this" {
  service_account_id = google_service_account.this.id
}

resource "datadog_monitor" "cpumonitor" {
  name    = "cpu monitor"
  type    = "metric alert"
  message = "CPU usage alert"
  query   = "avg(last_1m):avg:system.cpu.system{*} by {host} > 70"

  monitor_thresholds {
    ok                = 20
    warning_recovery  = 45
    warning           = 50
    critical          = 70
    critical_recovery = 65
  }

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  include_tags = true
}