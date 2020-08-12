
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


resource "helm_release" "prometheus-operator" {
  name       = var.prometheus_operator_release_name
  chart      = "prometheus-operator"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = var.prometheus_operator_namespace
  version    = var.prometheus_operator_chart_version
  values     = [data.template_file.prometheus-operator-values.rendered]
  atomic     = true

  lifecycle {
    ignore_changes = [keyring]
  }
}
