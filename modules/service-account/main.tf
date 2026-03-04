locals {
	oidc_issuer_hostpath = replace(var.cluster_oidc_issuer_url, "https://", "")
	oidc_thumbprint_list_effective = var.oidc_thumbprint_list != null ? var.oidc_thumbprint_list : [
		data.tls_certificate.oidc.certificates[length(data.tls_certificate.oidc.certificates) - 1].sha1_fingerprint
	]
}

data "tls_certificate" "oidc" {
	url = var.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "this" {
	count = var.create_oidc_provider ? 1 : 0

	url             = var.cluster_oidc_issuer_url
	client_id_list  = ["sts.amazonaws.com"]
	thumbprint_list = local.oidc_thumbprint_list_effective

	tags = var.tags
}

resource "aws_iam_role" "this" {
	name = var.iam_role_name

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect = "Allow"
				Principal = {
					Federated = var.create_oidc_provider ? aws_iam_openid_connect_provider.this[0].arn : var.oidc_provider_arn
				}
				Action = "sts:AssumeRoleWithWebIdentity"
				Condition = {
					StringEquals = {
						"${local.oidc_issuer_hostpath}:aud" = "sts.amazonaws.com"
						"${local.oidc_issuer_hostpath}:sub" = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
					}
				}
			}
		]
	})

	tags = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
	for_each = toset(var.policy_arns)

	role       = aws_iam_role.this.name
	policy_arn = each.value
}

resource "aws_iam_policy" "inline_custom" {
	count = var.inline_policy_json != null ? 1 : 0

	name   = var.inline_policy_name
	policy = var.inline_policy_json

	tags = var.tags
}

resource "aws_iam_role_policy_attachment" "inline_custom" {
	count = var.inline_policy_json != null ? 1 : 0

	role       = aws_iam_role.this.name
	policy_arn = aws_iam_policy.inline_custom[0].arn
}
