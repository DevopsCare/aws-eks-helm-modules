
#
# Copyright (c) 2020 Risk Focus Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

alertmanager:
  service:
    annotations:
      fabric8.io/expose: "true"
      fabric8.io/ingress.name: alertmanager
      fabric8.io/ingress.annotations: |-
        kubernetes.io/ingress.class: nginx
        cert-manager.io/cluster-issuer: letsencrypt-prod
  %{ if keycloak_enabled }
        nginx.ingress.kubernetes.io/auth-signin: https://${oauth_proxy}/oauth2/start?rd=$request_uri
        nginx.ingress.kubernetes.io/auth-url: https://${oauth_proxy}/oauth2/auth
   %{ endif }


  resources:
    limits:
      cpu: 200m
      memory: 600Mi
    requests:
      cpu: 10m
      memory: 400Mi


prometheusOperator:
  resources:
    limits:
      cpu: 200m
      memory: 200Mi
    requests:
      cpu: 100m
      memory: 100Mi

grafana:
  adminPassword: sweetTapDancing
  persistence:
    enabled: true

  service:
    annotations:
      fabric8.io/expose: "true"
      fabric8.io/ingress.annotations: "kubernetes.io/ingress.class: nginx\ncert-manager.io/cluster-issuer: letsencrypt-prod"
      fabric8.io/ingress.name: ${grafana_ingress_name}

  grafana.ini:
    server:
      domain: ${grafana_ingress_name}.${namespace}.${domain}
      root_url: "%(protocol)s://%(domain)s/"

  %{ if keycloak_enabled }
    auth:
      oauth_auto_login: true
    auth.generic_oauth:
      enabled: true
      allow_sign_up: true
      client_id: oauth
      client_secret: ${client_secret}
      auth_url: https://${keycloak_domain}/auth/realms/weissr/protocol/openid-connect/auth
      token_url: https://${keycloak_domain}/auth/realms/weissr/protocol/openid-connect/token
      api_url: https://${keycloak_domain}/auth/realms/weissr/protocol/openid-connect/userinfo
  %{ endif }

  resources:
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 128Mi

prometheus:
  enableAdminApi: true

  service:
    annotations:
      fabric8.io/expose: "true"
      fabric8.io/ingress.name: prometheus
      fabric8.io/ingress.annotations: |-
        kubernetes.io/ingress.class: nginx
        cert-manager.io/cluster-issuer: letsencrypt-prod
  %{ if keycloak_enabled }
        nginx.ingress.kubernetes.io/auth-signin: https://${oauth_proxy}/oauth2/start?rd=$request_uri
        nginx.ingress.kubernetes.io/auth-url: https://${oauth_proxy}/oauth2/auth
  %{ endif }

  resources:
    limits:
      cpu: 4
      memory: 5Gi
    requests:
      cpu: 1
      memory: 2Gi

  # Allow old style annotation based scrape
  prometheusSpec:
    additionalScrapeConfigs:
      # Scrape config for service endpoints.
      #
      # The relabeling allows the actual service scrape endpoint to be configured via the following annotations:
      #
      # * `prometheus.io/scrape`: Only scrape services that have a value of `true`
      # * `prometheus.io/scheme`: If the metrics endpoint is secured then you will need to set this to `https` & most likely set the `tls_config` of the scrape config.
      # * `prometheus.io/path`: If the metrics path is not `/metrics` override this.
      # * `prometheus.io/port`: If the metrics are exposed on a different port to the service then set this appropriately.
      - job_name: 'kubernetes-service-endpoints'

        kubernetes_sd_configs:
          - role: endpoints

        relabel_configs:
          - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
            action: keep
            regex: true
          - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]
            action: replace
            target_label: __scheme__
            regex: (https?)
          - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)
          - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
            action: replace
            target_label: __address__
            regex: ([^:]+)(?::\d+)?;(\d+)
            replacement: $1:$2
          - action: labelmap
            regex: __meta_kubernetes_service_label_(.+)
          - source_labels: [__meta_kubernetes_namespace]
            action: replace
            target_label: kubernetes_namespace
          - source_labels: [__meta_kubernetes_service_name]
            action: replace
            target_label: kubernetes_name
          - source_labels: [__meta_kubernetes_service_name]
            action: drop
            regex: 'node-exporter'

      # Example scrape config for pods
      #
      # The relabeling allows the actual pod scrape endpoint to be configured via the
      # following annotations:
      #
      # * `prometheus.io/scrape`: Only scrape pods that have a value of `true`
      # * `prometheus.io/path`: If the metrics path is not `/metrics` override this.
      # * `prometheus.io/port`: Scrape the pod on the indicated port instead of the default of `9102`.
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)
          - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
            action: replace
            regex: ([^:]+)(?::\d+)?;(\d+)
            replacement: $1:$2
            target_label: __address__
          - action: labelmap
            regex: __meta_kubernetes_pod_label_(.+)
          - source_labels: [__meta_kubernetes_namespace]
            action: replace
            target_label: kubernetes_namespace
          - source_labels: [__meta_kubernetes_pod_name]
            action: replace
            target_label: kubernetes_pod_name

# EKS Specifics https://github.com/helm/charts/issues/10517#issuecomment-469407481
coreDns:
  service:
    selector:
      k8s-app: kube-dns
# Not monitoring etcd, kube-scheduler, or kube-controller-manager because it is managed by EKS
defaultRules:
  rules:
    etcd: false
    kubeScheduler: false
kubeControllerManager:
  enabled: false
kubeEtcd:
  enabled: false
kubeScheduler:
  enabled: false

# Other specifics https://github.com/awslabs/amazon-eks-ami/issues/128#issuecomment-454085310
kubelet:
  serviceMonitor:
    https: true
