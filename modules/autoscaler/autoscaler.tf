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

resource "helm_release" "autoscaler" {
  count         = var.autoscaler_enabled
  name          = var.autoscaler_release_name
  chart         = "cluster-autoscaler"
  repository    = "https://kubernetes.github.io/autoscaler"
  namespace     = var.autoscaler_namespace
  version       = var.autoscaler_chart_version
  timeout       = var.timeout
  atomic        = true
  recreate_pods = true
  lint          = true

  values = [
    templatefile("${path.module}/templates/values.yaml",
      { awsRegion      = var.aws_region,
        iamRole        = module.iam_assumable_role_admin.this_iam_role_arn,
        serviceAccount = var.autoscaler_release_name,
        clusterName    = var.cluster_name
      }
    ),
    var.autoscaler_additional_settings
  ]
}
