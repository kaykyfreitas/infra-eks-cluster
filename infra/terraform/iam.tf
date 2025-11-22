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

resource "aws_iam_role_policy_attachment" "eks_admin_role_admin_access" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}