provider "helm" {
	kubernetes = {
		host                   = var.cluster_endpoint
		cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
		exec = {
			api_version = "client.authentication.k8s.io/v1beta1"
			command     = "aws"
			args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", var.region]
		}
	}
}

provider "kubernetes" {
	host                   = var.cluster_endpoint
	cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)

	exec {
		api_version = "client.authentication.k8s.io/v1beta1"
		command     = "aws"
		args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", var.region]
	}
}

resource "aws_acm_certificate" "ingress" {
	count = var.enable_https && var.create_route53_records ? 1 : 0

	domain_name               = var.argo_cd_ingress_host
	subject_alternative_names = [var.grafana_ingress_host]
	validation_method         = "DNS"

	lifecycle {
		create_before_destroy = true
	}

	tags = var.tags
}

resource "aws_route53_record" "acm_validation" {
	for_each = var.enable_https && var.create_route53_records ? {
		for dvo in aws_acm_certificate.ingress[0].domain_validation_options : dvo.domain_name => {
			name   = dvo.resource_record_name
			record = dvo.resource_record_value
			type   = dvo.resource_record_type
		}
	} : {}

	allow_overwrite = true
	name            = each.value.name
	ttl             = 60
	type            = each.value.type
	zone_id         = var.route53_zone_id
	records         = [each.value.record]
}

resource "aws_acm_certificate_validation" "ingress" {
	count = var.enable_https && var.create_route53_records ? 1 : 0

	certificate_arn         = aws_acm_certificate.ingress[0].arn
	validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

resource "aws_eks_addon" "coredns" {
	count = var.enable_coredns ? 1 : 0

	cluster_name                = var.cluster_name
	addon_name                  = "coredns"
	addon_version               = var.coredns_addon_version
	resolve_conflicts_on_create = "OVERWRITE"
	resolve_conflicts_on_update = "OVERWRITE"

	tags = var.tags
}

resource "helm_release" "ingress_nginx" {
	count = var.enable_ingress_nginx ? 1 : 0

	name             = "ingress-nginx"
	repository       = "https://kubernetes.github.io/ingress-nginx"
	chart            = "ingress-nginx"
	version          = var.ingress_nginx_chart_version
	namespace        = var.ingress_namespace
	create_namespace = true
	wait             = true
	timeout          = var.helm_timeout_seconds

	values = [
		yamlencode({
			controller = {
				service = {
					annotations = var.enable_https && var.create_route53_records ? {
						"service.beta.kubernetes.io/aws-load-balancer-type"             = "nlb"
						"service.beta.kubernetes.io/aws-load-balancer-scheme"           = "internet-facing"
						"service.beta.kubernetes.io/aws-load-balancer-ssl-cert"         = aws_acm_certificate_validation.ingress[0].certificate_arn
						"service.beta.kubernetes.io/aws-load-balancer-ssl-ports"        = "https"
						"service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "http"
					} : {
						"service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
						"service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
					}
				}
			}
		})
	]

	depends_on = [aws_eks_addon.coredns, aws_acm_certificate_validation.ingress]
}

resource "helm_release" "argo_cd" {
	count = var.enable_argo_cd ? 1 : 0

	name             = "argo-cd"
	repository       = "https://argoproj.github.io/argo-helm"
	chart            = "argo-cd"
	version          = var.argo_cd_chart_version
	namespace        = var.argo_cd_namespace
	create_namespace = true
	wait             = true
	timeout          = var.helm_timeout_seconds

	values = [
		yamlencode({
			configs = {
				cm = {
					url = "https://${var.argo_cd_ingress_host}"
				}
				params = {
					"server.insecure" = "true"
				}
			}
			server = {
				ingress = {
					enabled          = var.enable_argo_cd_ingress
					ingressClassName = var.ingress_class_name
					annotations      = {
						"kubernetes.io/ingress.class"                    = var.ingress_class_name
						"nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
					}
					hostname         = var.argo_cd_ingress_host
					hosts            = [var.argo_cd_ingress_host]
					tls              = []
				}
			}
		})
	]

	depends_on = [aws_eks_addon.coredns, helm_release.ingress_nginx]
}

resource "helm_release" "kube_prometheus_stack" {
	count = var.enable_kube_prometheus_stack ? 1 : 0

	name             = "kube-prometheus-stack"
	repository       = "https://prometheus-community.github.io/helm-charts"
	chart            = "kube-prometheus-stack"
	version          = var.kube_prometheus_stack_chart_version
	namespace        = var.monitoring_namespace
	create_namespace = true
	wait             = true
	timeout          = var.helm_timeout_seconds

	values = [
		yamlencode({
			grafana = {
				enabled = var.enable_grafana
				ingress = {
					enabled          = var.enable_grafana_ingress
					ingressClassName = var.ingress_class_name
					annotations      = {
						"kubernetes.io/ingress.class" = var.ingress_class_name
					}
					hosts            = [var.grafana_ingress_host]
				}
			}
			prometheus = {
				enabled = var.enable_prometheus
			}
			kubeApiServer = {
				enabled = var.enable_kube_api_server_monitoring
			}
		})
	]

	depends_on = [aws_eks_addon.coredns, helm_release.ingress_nginx]
}

resource "helm_release" "external_dns" {
	count = var.enable_external_dns ? 1 : 0

	name             = "external-dns"
	repository       = "https://kubernetes-sigs.github.io/external-dns"
	chart            = "external-dns"
	version          = var.external_dns_chart_version
	namespace        = var.external_dns_namespace
	create_namespace = true
	wait             = true
	timeout          = var.helm_timeout_seconds

	values = [
		yamlencode({
			provider = {
				name = "aws"
			}
			aws = {
				region = var.region
			}
			policy       = "upsert-only"
			txtOwnerId   = var.external_dns_txt_owner_id
			domainFilters = var.external_dns_domain_filters
			zoneIdFilters = var.external_dns_zone_id_filters
			sources      = ["ingress"]
			serviceAccount = {
				create = true
				name   = var.external_dns_service_account_name
				annotations = {
					"eks.amazonaws.com/role-arn" = var.external_dns_irsa_role_arn
				}
			}
		})
	]

	depends_on = [aws_eks_addon.coredns]
}

resource "time_sleep" "wait_for_ingress_lb" {
	count = var.create_route53_records ? 1 : 0

	create_duration = "${var.ingress_lb_wait_seconds}s"

	depends_on = [helm_release.ingress_nginx]
}

data "kubernetes_service" "ingress_nginx_controller" {
	count = var.create_route53_records ? 1 : 0

	metadata {
		name      = "ingress-nginx-controller"
		namespace = var.ingress_namespace
	}

	depends_on = [time_sleep.wait_for_ingress_lb]
}

resource "aws_route53_record" "argo_cd" {
	count = var.create_route53_records && var.enable_argo_cd_ingress ? 1 : 0

	zone_id = var.route53_zone_id
	name    = var.argo_cd_ingress_host
	type    = "CNAME"
	ttl     = 60
	records = [data.kubernetes_service.ingress_nginx_controller[0].status[0].load_balancer[0].ingress[0].hostname]

	depends_on = [helm_release.argo_cd, time_sleep.wait_for_ingress_lb]
}

resource "aws_route53_record" "grafana" {
	count = var.create_route53_records && var.enable_grafana_ingress ? 1 : 0

	zone_id = var.route53_zone_id
	name    = var.grafana_ingress_host
	type    = "CNAME"
	ttl     = 60
	records = [data.kubernetes_service.ingress_nginx_controller[0].status[0].load_balancer[0].ingress[0].hostname]

	depends_on = [helm_release.kube_prometheus_stack, time_sleep.wait_for_ingress_lb]
}
