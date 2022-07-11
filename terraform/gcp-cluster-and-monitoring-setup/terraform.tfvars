project_id = "gcp-project-name"
gcp_region = "europe-west2"
# credentials         = file("./key.json")
network_name = "gcp-network-name"

subnets = [
  {
    subnet_name   = "subnet-1-name"
    subnet_ip     = "10.200.0.0/16"
    subnet_region = "europe-west2"
  },
  {
    subnet_name   = "subnet-2-name"
    subnet_ip     = "10.210.0.0/16"
    subnet_region = "europe-west2"
  },
  {
    subnet_name   = "subnet-3-name"
    subnet_ip     = "10.220.0.0/16"
    subnet_region = "europe-west2"
  },
]

secondary_ranges = {
  subnet-01 = [
    {
      range_name    = "sec-subnet1-name"
      ip_cidr_range = "192.168.160.0/24"
  }],
  subnet-02 = [
    {
      range_name    = "sec-subnet2-name"
      ip_cidr_range = "192.168.170.0/24"
  }],
  subnet-03 = [
    {
      range_name    = "qsec-subnet3-name"
      ip_cidr_range = "192.168.180.0/24"
  }],
}

routes = [
  {
    name              = "egress-internet-name"
    description       = "route through IGW to access internet"
    destination_range = "0.0.0.0/0"
    tags              = "egress-tag"
    next_hop_internet = "true"
    priority          = 20
  },
]

######################################
# GKE VARIABLE VALUES
######################################
cluster_name               = "gke-cluster-name"
zones                      = ["europe-west2-a", "europe-west2-b", "europe-west2-c"]
ip_range_pods              = ""
ip_range_services          = ""
http_load_balancing        = true
horizontal_pod_autoscaling = true
network_policy             = true
enable_private_endpoint    = false
enable_private_nodes       = true
master_ipv4_cidr_block     = "10.121.0.0/28"
machine_type               = "e2-standard-2"
image_type                 = "COS"
service_account            = "gcp-service-account-value"
maintenance_start_time     = "23:00"
#cluster_autoscaling                = true
machine_type_backup = "e2-medium"


######################################
# CERT VARIABLE VALUES
######################################
cluster_issuer_email                   = ""
cluster_issuer_name                    = ""
cluster_issuer_private_key_secret_name = ""

######################################
# Redis
######################################
redis_name        = "redis-name"
tier              = "BASIC"
redis_memory      = 1
redis_location    = "europe-west2-a"
redis_version     = "REDIS_4_0"
reserved_ip_range = "10.90.20.0/29"

######################################
# Monitoring
######################################
grafana_service_type                       = "NodePort"
grafana_replica                            = 1
alertmanager_service_type                  = "NodePort"
alertmanager_replica                       = 1
kubestate_replica                          = 1
prometheus_replica                         = 1
monitoring_name_space                      = "default"
reloader_name_space                        = "kube-system"
kubestate_name_space                       = "kube-system"
alertmanager_node_port                     = 31000
grafana_node_port                          = 32000
grafana_persistent_volume_claim_storage    = "50Gi"
storage_class_name                         = "standard"
prometheus_node_port                       = 30000
prometheus_service_type                    = "NodePort"
prometheus_persistent_volume_claim_storage = "50Gi"

##################################
# DATADOG
###################################
datadog_api_key = "datadog_api_key"
datadog_app_key = "datadog_app_key"
datadog_api_url = "https://api.datadoghq.eu/"