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

resource "null_resource" "crd" {
  triggers = {
    crd = sha1(file("${path.module}/files/crd.yaml"))
  }

  provisioner "local-exec" {
    command = <<EOT
      kubectl apply --kubeconfig ${var.kubeconfig} -f ${path.module}/files/crd.yaml
    EOT
  }
}

resource "local_file" "issuers" {
  content  = data.template_file.issuers.rendered
  filename = "${path.module}/issuers.yaml"
}

resource "null_resource" "issuers" {
  triggers = {
    issuers = local_file.issuers.id
  }

  provisioner "local-exec" {
    command = <<EOT
      kubectl apply --kubeconfig ${var.kubeconfig} -f ${path.module}/issuers.yaml
    EOT
  }

  depends_on = [local_file.issuers, null_resource.crd, helm_release.certmanager]
}

resource "helm_release" "certmanager" {
  depends_on    = [null_resource.crd]
  name          = var.certmanager_release_name
  chart         = "cert-manager"
  repository    = "https://charts.jetstack.io"
  namespace     = var.certmanager_namespace
  version       = var.certmanager_chart_version
  atomic        = true
  recreate_pods = true

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        iamRole           = module.iam_assumable_role_admin.this_iam_role_arn,
        serviceAccount    = var.certmanager_release_name,
        defaultIssuerName = var.staging ? "letsencrypt-staging" : "letsencrypt-prod",
        defaultIssuerKind = "ClusterIssuer"
    })
  ]
}
