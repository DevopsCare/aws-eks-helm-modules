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

resource "helm_release" "external-dns" {
  count         = var.external_dns_enabled
  name          = var.external_dns_release_name
  repository    = "https://charts.bitnami.com/bitnami"
  chart         = "external-dns"
  namespace     = var.external_dns_namespace
  version       = var.external_dns_chart_version
  atomic        = true
  recreate_pods = true

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        awsRegion      = var.aws_region,
        iam_role       = module.iam_assumable_role_admin.this_iam_role_arn,
        serviceAccount = var.external_dns_release_name,
        txtOwnerId     = var.external_dns_txt_owner_id
      }
    ),
    var.external_dns_additional_settings
  ]
}
