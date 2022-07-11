/******************************************
	Provider configuration
 *****************************************/
provider "google" {
  # version     = "~> 3.69.0"
  project     = var.project_id
  region      = var.gcp_region
  credentials = file("./key.json")
}

provider "google-beta" {
  # version     = "=> 3.69.0"
  project     = var.project_id
  region      = var.gcp_region
  credentials = file("./key.json")
}

terraform {
  backend "gcs" {
    bucket      = "tfstate_qa_store"
    prefix      = "gcp/default.tfstate"
    credentials = "./key.json"
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                                 = "./modules/vpc"
  network_name                           = var.network_name
  auto_create_subnetworks                = var.auto_create_subnetworks
  routing_mode                           = var.routing_mode
  project_id                             = var.project_id
  description                            = var.description
  shared_vpc_host                        = var.shared_vpc_host
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
}

/******************************************
	Subnet configuration
 *****************************************/
module "subnets" {
  source           = "./modules/subnets"
  project_id       = var.project_id
  network_name     = module.vpc.network_name
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
}

/******************************************
	Routes
 *****************************************/
module "routes" {
  source            = "./modules/routes"
  project_id        = var.project_id
  network_name      = module.vpc.network_name
  routes            = var.routes
  subnet_region     = var.gcp_region
  module_depends_on = [module.subnets.subnets]
}

module "gke" {
  source                     = "./modules/private-cluster"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.gcp_region
  zones                      = var.zones
  network                    = module.vpc.network_name
  subnetwork                 = element(module.subnets.subnets_names, 2)
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = var.http_load_balancing
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  network_policy             = var.network_policy
  enable_private_endpoint    = var.enable_private_endpoint
  enable_private_nodes       = var.enable_private_nodes
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  maintenance_start_time     = var.maintenance_start_time
  #cluster_autoscaling        = var.cluster_autoscaling


  node_pools = [
    {
      name               = "main-node-pool"
      machine_type       = var.machine_type
      node_locations     = "europe-west2-a,europe-west2-b,europe-west2-c"
      min_count          = 2
      max_count          = 6
      disk_size_gb       = 50
      image_type         = var.image_type
      service_account    = var.service_account
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
    {
      name               = "backup-node-pool"
      machine_type       = var.machine_type_backup
      node_locations     = "europe-west2-a,europe-west2-b,europe-west2-c"
      min_count          = 2
      max_count          = 6
      disk_size_gb       = 50
      image_type         = var.image_type
      service_account    = var.service_account
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = "true"
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

/******************************************
	Nginx Ingress Controller
 *****************************************/
resource "google_compute_address" "ingress_ip_address" {
  name = "gcp-nginx-controller"
}

module "nginx-controller" {
  source = "./modules/ingress-controller"
}

module "cert-manager" {
  source = "./modules/cert-manager"
}

/******************************************
	Redis
 *****************************************/
module "redis" {
  source   = "./modules/redis"
  name     = var.redis_name
  tier     = var.tier
  memory   = var.redis_memory
  location = var.redis_location
  # alternative_location_id               = var.alternative_location_id
  authorized_network = var.network_name
  redis_version      = var.redis_version
  display_name       = var.redis_name
  reserved_ip_range  = var.reserved_ip_range
}

/******************************************
	Monitoring
 *****************************************/
module "prometheus" {
  #https://github.com/prometheus/prometheus
  source                                     = "./modules/cluster-monitoring/prometheus"
  prometheus_replica                         = var.prometheus_replica
  monitoring_name_space                      = var.monitoring_name_space
  prometheus_node_port                       = var.prometheus_node_port
  prometheus_service_type                    = var.prometheus_service_type
  storage_class_name                         = var.storage_class_name
  prometheus_persistent_volume_claim_storage = var.prometheus_persistent_volume_claim_storage
}

module "kube-state-metrics" {
  #https://github.com/kubernetes/kube-state-metrics
  source               = "./modules/cluster-monitoring/kube-state-metrics"
  kubestate_replica    = var.kubestate_replica
  kubestate_name_space = var.kubestate_name_space
}

module "alertmanager" {
  #https://github.com/prometheus/alertmanager
  source = "./modules/cluster-monitoring/alertmanager"
  # alertmanager_ingress_host = var.alertmanager_ingress_host
  monitoring_name_space     = var.monitoring_name_space
  alertmanager_service_type = var.alertmanager_service_type
  alertmanager_replica      = var.alertmanager_replica
  alertmanager_node_port    = var.alertmanager_node_port

}

module "grafana" {
  #https://github.com/grafana/grafana
  source = "./modules/cluster-monitoring/grafana"
  # grafana_ingress_host = var.grafana_ingress_host
  monitoring_name_space                   = var.monitoring_name_space
  grafana_service_type                    = var.grafana_service_type
  grafana_replica                         = var.grafana_replica
  grafana_node_port                       = var.grafana_node_port
  grafana_persistent_volume_claim_storage = var.grafana_persistent_volume_claim_storage
  storage_class_name                      = var.storage_class_name

}

module "reloader" {
  # https://github.com/stakater/Reloader
  source              = "./modules/cluster-monitoring/reloader"
  reloader_name_space = var.reloader_name_space
}

module "prometheus-node-exporter" {
  source                = "./modules/cluster-monitoring/prometheus-node-exporter"
  monitoring_name_space = var.monitoring_name_space
  helm_stable           = "https://prometheus-community.github.io/helm-charts"

}

module "prometheus-adaptor" {
  source = "./modules/cluster-monitoring/prom-node-adaptor"

}

module "loki-logs" {
  source = "./modules/cluster-monitoring/loki"

}

module "datadog-integration" {
  source          = "./modules/cluster-monitoring/datadog"
  project_id      = var.project_id
  datadog_api_key = var.datadog_api_key
  datadog_app_key = var.datadog_app_key
  datadog_api_url = var.datadog_api_url

}

module "datadog-agent" {
  source          = "./modules/cluster-monitoring/datadog-metrics-agent"
  datadog_api_key = var.datadog_api_key
  datadog_app_key = var.datadog_app_key
  settings = {
    // Add tolerations for all taints example
    "agents.tolerations[0].effect"   = "NoSchedule"
    "agents.tolerations[0].operator" = "Exists"
    // Increase rolling update maxUnavailable example
    "agents.updateStrategy.rollingUpdate.maxUnavailable" = "30"
  }

}


