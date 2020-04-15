module "elk" {
  source              = "./modules/elk"
  aws_region          = local.aws_region
  root_domain         = var.project_prefix
  subnet_ids          = [var.vpc.private_subnets[0]]
  vpc_id              = var.vpc.vpc_id
  oauth_proxy_address = var.keycloak_enabled ? var.keycloak_oauth_proxy_address : ""

  ip_whitelist   = ["10.0.0.0/8"]
  instance_count = "2"
  ebs_size       = "35"

  curator_namespace      = kubernetes_namespace.logging.id
  nginx_kibana_namespace = kubernetes_namespace.logging.id
}

module "filebeat" {
  source                 = "./modules/filebeat"
  elasticsearch_endpoint = module.elk.elasticsearch_endpoint
  filebeat_namespace     = kubernetes_namespace.logging.id
}

