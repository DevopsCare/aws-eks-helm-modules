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

variable "project_prefix" {}
variable "project_fqdn" {}

variable "ip_whitelist" {
  type    = list(string)
  default = []
}

variable "whitelist_github_hooks" {
  type    = bool
  default = true
}

variable "whitelist_atlassian_outgoing" {
  type    = bool
  default = false
}

variable "dashboard_helm_chart_version" {
  type    = string
  default = "5.0.5"
}

variable "metrics_helm_chart_version" {
  type    = string
  default = "3.7.0"
}

variable "nginx_ingress_helm_chart_version" {
  type    = string
  default = "3.29.0"
}

variable "nginx_ingress_additional_annotations" {
  type    = map(any)
  default = {}
}

variable "letsencrypt-email" {
  description = "Email for registration in Letsencrypt"
  default     = "acme@example.com"
}

variable "extra_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

variable "elasticsearch_log_collector_enabled" {
  default = false
}

variable "aws_ebs_csi_driver_helm_chart_version" {
  type    = string
  default = "2.3.0"
}

variable "aws_efs_csi_driver_helm_chart_version" {
  type    = string
  default = "2.2.0"
}

// Keycloak
variable "keycloak_enabled" {
  default = false
}

variable "keycloak_client_secret" {
  type    = string
  default = ""
}

variable "keycloak_domain" {
  type    = string
  default = ""
}

variable "keycloak_oauth_proxy_address" {
  type    = string
  default = ""
}

variable "vpc" {}
variable "eks_cluster" {}

variable "kubernetes_host" {}
variable "kubernetes_ca_certificate" {}
variable "kubernetes_token" {}
