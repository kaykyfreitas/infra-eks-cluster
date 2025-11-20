terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket       = var.backend_bucket_name
    key          = "${var.environment}/${var.repository_name}/terraform-state-file"
    region       = var.region
    encrypt      = true
    use_lockfile = true
  }
}

module "vpc" {
  source              = "./modules/vpc"
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  availability_zone   = var.availability_zone
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  eks_cluster_name    = var.eks_cluster_name
  environment         = var.environment
}

module "eks" {
  source           = "./modules/eks"
  region           = var.region
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.private_subnet_ids
  eks_cluster_name = var.eks_cluster_name
  cluster_version  = var.cluster_version
  node_groups      = var.node_groups
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_config_map" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      concat(
        [
          {
            rolearn  = module.eks.node_role_arn
            username = "system:node:{{EC2PrivateDNSName}}"
            groups   = ["system:bootstrappers", "system:nodes"]
          },
          {
            rolearn  = aws_iam_role.eks_admin_role.arn
            username = "eks-admin"
            groups   = ["system:masters"]
          }
        ],
        var.cluster_roles
      )
    )

    mapUsers = yamlencode(
      concat(
        [
          {
            userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            username = "aws-root-admin"
            groups   = ["system:masters"]
          }
        ],
        var.cluster_users
      )
    )
  }
}