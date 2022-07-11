terraform {
  required_version = ">= 0.13.0"
}

provider "helm" {
  #source  = "hashicorp/helm"
  version = ">= 1.0.0"

  kubernetes {
    config_path = "./config"
  }
}




# provider "helm" {
#   version = "~> 0.10"

#   kubernetes {
#     config_path = "./config"
#   }
# }
