# Variable declarations with default values
variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  default     = "8bd8f56cd346b49030c8d71082a65ef6"
}

variable "datadog_app_key" {
  description = "Datadog APP Key"
  type        = string
  default     = "f801f06f25777a43d75c2aaae281aa24acf89db8"
}

# Terraform required providers
terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "<= 3.8.1"
    }
  }
}

# Configure the Datadog provider
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.datadoghq.eu/"
}

# Datadog monitor resource
resource "datadog_monitor" "monitor" {
  name    = "Running Too Many Pods"
  type    = "metric alert"
  message = "Scale Down those pods"
  query   = "max(last_5m):kubernetes_state.pod.status_phase{phase:running,namespace:default} > 8"

  monitor_thresholds {
    warning    = 6
    critical   = 8
  }

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  include_tags = true

  tags = ["cluster:minikube", "createdBy:terraform"]
}
