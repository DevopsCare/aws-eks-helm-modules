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

resource "helm_release" "sentry" {
  name          = var.sentry_release_name
  chart         = "sentry"
  repository = "https://charts.helm.sh/stable"
  namespace     = var.sentry_namespace
  version       = var.sentry_chart_version
  atomic        = true
  recreate_pods = true
  lint          = true

  values = [file("${path.root}/values/sentry.yaml"),
    var.sentry_additional_settings,
  ]

  # set {
  #   name  = "web.env.GITHUB_APP_ID"
  #   value = data.vault_generic_secret.sentry.data["github_app_id"]
  # }


  # set {
  #   name  = "web.env.GITHUB_API_SECRET"
  #   value = data.vault_generic_secret.sentry.data["github_api_secret"]
  # }


  # set {
  #   name  = "email.user"
  #   value = data.vault_generic_secret.sentry.data["smtp_username"]
  # }


  # set {
  #   name  = "email.password"
  #   value = data.vault_generic_secret.sentry.data["smtp_password"]
  # }


  # set {
  #   name  = "user.password"
  #   value = data.vault_generic_secret.sentry.data["sentry_user_password"]
  # }


  # set {
  #   name  = "postgresql.postgresPassword"
  #   value = data.vault_generic_secret.sentry.data["sentry_postgresql_password"]
  # }


  # set {
  #   name  = "redis.password"
  #   value = data.vault_generic_secret.sentry.data["sentry_redis_password"]
  # }


  # set {
  #   name  = "sentrySecret"
  #   value = data.vault_generic_secret.sentry.data["sentry_sentry_secret"]
  # }
}
