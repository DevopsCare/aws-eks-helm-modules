resource "helm_release" "aws-efs-csi-driver" {
  depends_on = [var.eks_cluster]
  name       = "aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  version    = var.aws_efs_csi_driver_helm_chart_version
  namespace  = "kube-system"
  values = [templatefile("${path.module}/templates/efs-csi.yaml", {
    iam_role = module.irsa_efs_csi.this_iam_role_arn
  })]
  atomic = true
}


module "irsa_efs_csi" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "eks-aws-efs-csi-driver"
  role_description              = "EFS CSI Driver Role"
  provider_url                  = replace(var.eks_cluster.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.efs_controller_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
}

data "aws_iam_policy_document" "efs_controller_policy_doc" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:CreateAccessPoint"
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["elasticfilesystem:DeleteAccessPoint"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "efs_controller_policy" {
  name_prefix = "aws-efs-csi-driver"
  policy      = data.aws_iam_policy_document.efs_controller_policy_doc.json
}
