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
  name    = "Kubernetes ImagePullBackOff Alert - hello-world-container"
  type    = "log alert"
  message = "Alert: The hello-world-container in the hello-world-deployment is experiencing ImagePullBackOff. Please check the container image configuration."
  query   = "logs('service:kubernetes AND @msg:\"ImagePullBackOff\" AND kubernetes.container_name:hello-world-container AND kubernetes.deployment:hello-world-deployment').index('main').rollup('count').last('5m') > 0"

  monitor_thresholds {
    critical = 1
  }

  notify_no_data    = false
  renotify_interval = 60

  notify_audit = false
  include_tags = true

  tags = ["cluster:minikube", "createdBy:terraform"]
}
