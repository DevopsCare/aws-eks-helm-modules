service:
  type: ClusterIP
  annotations:
    fabric8.io/expose: "${expose_enabled}"
    fabric8.io/ingress.annotations: |-
      kubernetes.io/ingress.class: nginx
      certmanager.k8s.io/cluster-issuer: letsencrypt-prod
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
      proxy_pass ${elasticsearch_endpoint}/;

      proxy_set_header Accept-Encoding "";
      sub_filter_types *;
      sub_filter_once off;
      proxy_buffer_size 128k;
      proxy_buffers 4 256k;
      proxy_busy_buffers_size 256k;
    }

    location / {
      proxy_pass ${elasticsearch_endpoint}/_plugin/kibana/;

      proxy_set_header Accept-Encoding "";
      sub_filter_types *;
      sub_filter_once off;
      proxy_buffer_size 128k;
      proxy_buffers 4 256k;
      proxy_busy_buffers_size 256k;
    }

    location /health-check {
      return 200;
    }
  }
