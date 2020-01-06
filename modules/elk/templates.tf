data "template_file" "curator-values" {
  template = file("${path.module}/templates/curator-values.yaml.tpl")

  vars = {
    elasticsearch_endpoint = "https://${aws_elasticsearch_domain.es.endpoint}"
    elasticsearch_port     = var.elasticsearch_port
  }
}

data "template_file" "nginx-kibana-values" {
  template = file("${path.module}/templates/nginx-kibana-values.yaml.tpl")

  vars = {
    elasticsearch_endpoint = "https://${aws_elasticsearch_domain.es.endpoint}:${var.elasticsearch_port}"
    expose_enabled         = "true"
    oauth_proxy            = var.oauth_proxy_address
  }
}

