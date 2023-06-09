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

resource "helm_release" "elasticsearch-curator" {
  count      = var.enabled ? var.curator_enabled : 0
  name       = var.curator_release_name
  chart      = "elasticsearch-curator"
  repository = "https://charts.helm.sh/stable"
  namespace  = var.curator_namespace
  values     = [data.template_file.curator-values[0].rendered]
  version    = var.curator_chart_version
  atomic     = true
}

