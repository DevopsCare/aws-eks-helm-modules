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

data "template_file" "prometheus-stack-values" {
  template = file("${path.module}/templates/prometheus-values.yaml.tpl")

  vars = {
    grafana_ingress_name = var.grafana_ingress_name
    domain               = var.domain
    admin_password       = var.admin_password

    keycloak_enabled = var.keycloak_enabled
    keycloak_domain  = var.keycloak_domain
    client_secret    = var.keycloak_client_secret
    namespace        = var.prometheus_stack_namespace
    oauth_proxy      = var.oauth_proxy_address
  }
}
