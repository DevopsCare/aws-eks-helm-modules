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

service:
  type: ClusterIP
  annotations:
    fabric8.io/expose: "${expose_enabled}"
    fabric8.io/ingress.annotations: |-
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
    %{ if oauth_proxy != "" }
      nginx.ingress.kubernetes.io/auth-signin: https://${oauth_proxy}/oauth2/start?rd=$request_uri
      nginx.ingress.kubernetes.io/auth-url: https://${oauth_proxy}/oauth2/auth
    %{ endif }
    fabric8.io/ingress.name: kibana
  port: "8080"

livenessProbe:
  httpGet:
    path: /health-check
readinessProbe:
  httpGet:
    path: /health-check

serverBlock: |-
  server {
    listen 0.0.0.0:8080;

    location /_plugin/kibana/ {
      proxy_set_header Accept-Encoding "";
      sub_filter_types *;
      sub_filter_once off;
      proxy_buffer_size 128k;
      proxy_buffers 4 256k;
      proxy_busy_buffers_size 256k;

      proxy_pass ${elasticsearch_endpoint}/_plugin/kibana/;
    }

    location / {
      proxy_set_header Accept-Encoding "";
      sub_filter_types *;
      sub_filter_once off;
      proxy_buffer_size 128k;
      proxy_buffers 4 256k;
      proxy_busy_buffers_size 256k;

      proxy_pass ${elasticsearch_endpoint}/_plugin/kibana/;
    }

    location /health-check {
      return 200;
    }
  }
