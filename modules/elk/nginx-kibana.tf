
/*
*Copyright (c) 2020 Risk Focus Inc.
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


resource "helm_release" "nginx-kibana" {
  name       = var.nginx_kibana_release_name
  chart      = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.nginx_kibana_namespace
  values     = [
    data.template_file.nginx-kibana-values.rendered,
  ]
  version    = var.nginx_kibana_chart_version

  lifecycle {
    ignore_changes = [
      keyring,
    ]
  }
}

