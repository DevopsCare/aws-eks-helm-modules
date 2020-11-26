module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.4.0"
  create_role                   = true
  role_name                     = "eks-${var.autoscaler_release_name}"
  provider_url                  = var.irsa_provider_url
  number_of_role_policy_arns    = 1
  role_policy_arns              = [aws_iam_policy.irsa.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.autoscaler_namespace}:${var.autoscaler_release_name}"]
}

resource "aws_iam_policy" "irsa" {
  name_prefix = "eks-cluster-autoscaler"
  description = "EKS cluster-autoscaler policy"
  policy      = data.aws_iam_policy_document.irsa.json
}

data "aws_iam_policy_document" "irsa" {
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}
