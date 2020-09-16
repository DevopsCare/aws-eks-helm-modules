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

resource "helm_release" "kube2iam" {
  count      = var.kube2iam_enabled
  name       = var.kube2iam_release_name
  chart      = "kube2iam"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = var.kube2iam_namespace
  version    = var.kube2iam_chart_version
  timeout    = var.timeout
  atomic     = true

  values = [file("${path.module}/files/values.yaml"),
    var.kube2iam_additional_settings,
  ]

  set {
    name  = "extraArgs.base-role-arn"
    value = var.kube2iam_base_role_arn
  }

  set {
    name  = "extraArgs.default-role"
    value = var.kube2iam_default_role
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}
