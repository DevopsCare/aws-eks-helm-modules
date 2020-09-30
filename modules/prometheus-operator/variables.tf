/*
* Copyright (c) 2020 Risk Focus Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

variable "domain" {
  type = string
}

variable "grafana_ingress_name" {
  default = "grafana"
}

// Keycloak
variable "keycloak_enabled" {
  default = false
}
variable "keycloak_domain" {
  type    = string
  default = ""
}
variable "keycloak_client_secret" {
  type    = string
  default = ""
}
variable "oauth_proxy_address" {
  description = "OAuth proxy address"
  default     = ""
}

variable "prometheus_operator_chart_version" {
  default = "8.12.13"
}

variable "prometheus_operator_namespace" {
  default = "monitoring"
}

variable "prometheus_operator_release_name" {
  default = "prometheus-operator"
}
