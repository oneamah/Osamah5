data "aws_caller_identity" "current" {}

module "networking" {
  source = "./modules/networking"
  region = var.region
  name_prefix          = var.name_prefix
  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  az_count             = var.az_count
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
  nat_gateway_delete_timeout = var.nat_gateway_delete_timeout
  create_bastion       = var.create_bastion
  bastion_name         = var.bastion_name
  bastion_instance_type = var.bastion_instance_type
  bastion_key_name     = var.bastion_key_name
  bastion_ami_id       = var.bastion_ami_id
  bastion_allowed_cidrs = var.bastion_allowed_cidrs
  bastion_security_group_name = var.bastion_security_group_name
  enable_bastion_ssm   = var.enable_bastion_ssm
  tags                 = var.tags
}

module "eks" {
  source = "./modules/eks"
  region = var.region
  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  cluster_authentication_mode = var.cluster_authentication_mode
  eks_cluster_role_arn      = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn   = module.iam.eks_node_group_role_arn
  cluster_subnet_ids        = module.networking.private_subnet_ids
  node_subnet_ids           = module.networking.private_subnet_ids
  cluster_security_group_id = module.sg.eks_cluster_security_group_id
  endpoint_public_access    = var.endpoint_public_access
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs
  enabled_cluster_log_types = var.enabled_cluster_log_types
  node_group_name           = var.node_group_name
  node_ami_type             = var.node_ami_type
  node_capacity_type        = var.node_capacity_type
  node_instance_types       = var.node_instance_types
  node_desired_size         = var.node_desired_size
  node_min_size             = var.node_min_size
  node_max_size             = var.node_max_size
  node_max_unavailable      = var.node_max_unavailable
  create_cluster_admin_access = var.create_cluster_admin_access
  cluster_admin_principal_arn = module.iam.cluster_admin_user_arn
  additional_admin_principal_arns = [data.aws_caller_identity.current.arn]
  tags                      = var.tags

  depends_on = [module.iam, module.networking, module.sg]
}

module "iam" {
  source = "./modules/iam"
  region = var.region
  eks_cluster_role_name    = var.eks_cluster_role_name
  eks_node_group_role_name = var.eks_node_group_role_name
  create_cluster_admin_user       = var.create_cluster_admin_user
  cluster_admin_user_name         = var.cluster_admin_user_name
  cluster_admin_user_force_destroy = var.cluster_admin_user_force_destroy
  tags                            = var.tags
}

module "helm" {
  source = "./modules/helm"
  region = var.region
  cluster_name                      = module.eks.cluster_name
  cluster_endpoint                  = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  enable_coredns                    = var.enable_coredns
  coredns_addon_version             = var.coredns_addon_version
  enable_ingress_nginx              = var.enable_ingress_nginx
  ingress_class_name                = var.ingress_class_name
  ingress_namespace                 = var.ingress_namespace
  ingress_nginx_chart_version       = var.ingress_nginx_chart_version
  enable_argo_cd                    = var.enable_argo_cd
  enable_argo_cd_ingress            = var.enable_argo_cd_ingress
  argo_cd_ingress_host              = var.argo_cd_ingress_host
  argo_cd_namespace                 = var.argo_cd_namespace
  argo_cd_chart_version             = var.argo_cd_chart_version
  enable_kube_prometheus_stack      = var.enable_kube_prometheus_stack
  monitoring_namespace              = var.monitoring_namespace
  kube_prometheus_stack_chart_version = var.kube_prometheus_stack_chart_version
  enable_grafana                    = var.enable_grafana
  enable_grafana_ingress            = var.enable_grafana_ingress
  grafana_ingress_host              = var.grafana_ingress_host
  create_route53_records            = var.create_route53_records
  route53_zone_id                   = var.route53_zone_id
  enable_https                      = var.enable_https
  ingress_lb_wait_seconds           = var.ingress_lb_wait_seconds
  enable_external_dns               = var.enable_external_dns
  external_dns_namespace            = var.external_dns_namespace
  external_dns_chart_version        = var.external_dns_chart_version
  external_dns_service_account_name = var.external_dns_service_account_name
  external_dns_irsa_role_arn        = module.external_dns_service_account.service_account_role_arn
  external_dns_domain_filters       = var.external_dns_domain_filters
  external_dns_zone_id_filters      = var.external_dns_zone_id_filters
  external_dns_txt_owner_id         = var.external_dns_txt_owner_id
  enable_prometheus                 = var.enable_prometheus
  enable_kube_api_server_monitoring = var.enable_kube_api_server_monitoring
  helm_timeout_seconds              = var.helm_timeout_seconds
  tags                              = var.tags
}

module "sg" {
  source = "./modules/sg"
  region = var.region
  vpc_id = module.networking.vpc_id
  bastion_security_group_id = module.networking.bastion_security_group_id
  enable_bastion_rules      = var.create_bastion

  depends_on = [module.networking]
}

module "service-account" {
  source = "./modules/service-account"
  region = var.region
  cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer
  create_oidc_provider      = var.create_oidc_provider
  oidc_provider_arn         = var.oidc_provider_arn
  oidc_thumbprint_list      = var.oidc_thumbprint_list
  service_account_namespace = var.service_account_namespace
  service_account_name      = var.service_account_name
  iam_role_name             = var.service_account_iam_role_name
  policy_arns               = var.service_account_policy_arns
  inline_policy_name        = var.service_account_inline_policy_name
  inline_policy_json        = var.service_account_inline_policy_json
  tags                      = var.tags

  depends_on = [module.eks]
}

module "external_dns_service_account" {
  source = "./modules/service-account"
  region = var.region
  cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer
  create_oidc_provider      = false
  oidc_provider_arn         = module.service-account.oidc_provider_arn
  service_account_namespace = var.external_dns_namespace
  service_account_name      = var.external_dns_service_account_name
  iam_role_name             = var.external_dns_iam_role_name
  policy_arns               = []
  inline_policy_name        = "external-dns-route53-policy"
  inline_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [
          "arn:aws:route53:::hostedzone/${var.route53_zone_id}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:GetChange"
        ]
        Resource = [
          "arn:aws:route53:::change/*"
        ]
      }
    ]
  })
  tags = var.tags

  depends_on = [module.service-account]
}
