/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "gcp_region" {
  description = "The region to provsion the infrastructure"
  type        = string
}

# variable "credentials" {
#   description = "The service account key for the project"

# }

variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = false
}

variable "subnets" {
  # type        = list(map(string))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
  default     = []
}

variable "delete_default_internet_gateway_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  default     = false
}


variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "zones" {
  type        = list(string)
  description = "GCP zones for the kubernetes node_poles"
}

# variable "gcp_zones" {
#   type        = list(string)
#   description = "GCP zones for the kubernetes deployment"
# }

# variable "subnet" {
#   type        = string 
#   description = "the subnetwork for the kuberntes deployment"
# }

variable "ip_range_pods" {
  type = string
}

variable "ip_range_services" {
  type = string
}

variable "http_load_balancing" {
  type = bool
}

variable "horizontal_pod_autoscaling" {
  type = bool
}

variable "network_policy" {
  type = bool
}

variable "enable_private_endpoint" {
  type = bool
}

variable "enable_private_nodes" {
  type = bool
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "image_type" {
  type = string
}

variable "service_account" {
  type = string
}

variable "maintenance_start_time" {
  type        = string
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
}


variable "cluster_issuer_email" {
  type = string
}

variable "cluster_issuer_name" {
  type = string
}

variable "cluster_issuer_private_key_secret_name" {
  type = string
}

# variable "cluster_autoscaling" {
#  type        = bool
#   description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
#   default     = true
# }

variable "default_network_name" {
  description = "The name of the default network"
  type        = string
}

variable "main_network_name" {
  description = "The name of the default network"
  type        = string
}


variable "redis_name" {
  description = "name of redis server"
  type        = string
}

variable "tier" {
  description = "tier of redis server"
  type        = string
}

variable "redis_memory" {
  description = "memory of redis server"
  type        = number
}

variable "redis_location" {
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

# variable "display_name" {
#   description = "display_name of redis server"
#   type        = string        
# }

variable "reserved_ip_range" {
  description = "reserved_ip_range of redis server"
  type        = string
}
variable "machine_type_backup" {
  type = string
}


######################################
# Monitoring
######################################

# variable "grafana_ingress_host" {
#   type        = string
#   default     = "grafana.winkels.ir"
# }


variable "grafana_service_type" {
  description = "type of kubernetes service for grafana"
  type        = string
  default     = "NodePort"
}


variable "grafana_replica" {
  description = "number of grafana replicas"
  type        = number
  default     = 1
}

# variable "alertmanager_ingress_host" {
#   type        = string
#   default     = "alertmanager.info"
# }


variable "alertmanager_service_type" {
  description = "type of kubernetes service for alertmanager"

  type    = string
  default = "NodePort"
}

variable "alertmanager_replica" {
  description = "number of alertmanager replicas"
  type        = number
  default     = 1
}


variable "kubestate_replica" {
  description = "number of kube-state-metrics replicas"

  type    = number
  default = 1
}

variable "prometheus_replica" {
  description = "number of prometheus replicas"
  type        = number
  default     = 2
}

variable "monitoring_name_space" {
  description = "defualt namespaace for monitoring management tools"
  type        = string
  default     = "monitoring"
}

variable "reloader_name_space" {
  description = "defualt namespaace for config reloader"
  type        = string
  default     = "kube-system"
}

variable "kubestate_name_space" {
  description = "defualt namespaace for metrics collector"

  type    = string
  default = "kube-system"
}


variable "alertmanager_node_port" {
  description = "port to expose alertmanager service"

  type    = number
  default = 31000
}

variable "grafana_node_port" {
  description = "port to expose grafana service"

  type    = number
  default = 32000
}


variable "grafana_persistent_volume_claim_storage" {
  description = "grafana storage size"

  type    = string
  default = "1Gi"
}

variable "storage_class_name" {
  description = "storageClass for dynamically provisioning"
  type        = string
  default     = "standard"
}

variable "prometheus_node_port" {
  description = "port to expose prometheus service"

  type    = number
  default = 30000
}

variable "prometheus_service_type" {
  description = "type of kubernetes service for prometheus"
  type        = string
  default     = "NodePort"
}

variable "prometheus_persistent_volume_claim_storage" {
  description = "proemtheus storage size"

  type    = string
  default = "3Gi"
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