############################################################
# IAM USER PARA ACESSO AO EKS
############################################################

resource "aws_iam_user" "eks_admin_user" {
  name = "eks-admin-user"
  tags = {
    ManagedBy = "terraform"
    Role      = "eks-admin"
  }
}

resource "aws_iam_access_key" "eks_admin_key" {
  user = aws_iam_user.eks_admin_user.name
}

############################################################
# ROLE IAM ADMIN PARA ASSUMIR PERMISSÕES DE ADMIN EKS
############################################################

resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_user.eks_admin_user.arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    ManagedBy = "terraform"
    Role      = "eks-admin"
  }
}

############################################################
# PERMISSÕES ADMINISTRATIVAS (AWS) PARA ESSA ROLE
############################################################

resource "aws_iam_role_policy_attachment" "eks_admin_role_admin_access" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

############################################################
# OUTPUTS ÚTEIS
############################################################

output "eks_admin_user_arn" {
  description = "ARN do usuário EKS admin"
  value       = aws_iam_user.eks_admin_user.arn
}

output "eks_admin_role_arn" {
  description = "ARN da role EKS admin"
  value       = aws_iam_role.eks_admin_role.arn
}

output "eks_admin_user_access_key" {
  description = "Access key para o usuário admin"
  value       = aws_iam_access_key.eks_admin_key.id
  sensitive   = true
}

output "eks_admin_user_secret_key" {
  description = "Secret key para o usuário admin"
  value       = aws_iam_access_key.eks_admin_key.secret
  sensitive   = true
}
