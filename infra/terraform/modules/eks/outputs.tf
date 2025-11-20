output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main-eks-cluster.endpoint
}

output "cluster_certificate_authority" {
  description = "EKS cluster certificate authority"
  value       = aws_eks_cluster.main-eks-cluster.certificate_authority[0].data
}

output "node_role_arn" {
  description = "IAM role used by EKS worker nodes"
  value       = aws_iam_role.eks_node_role.arn
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main-eks-cluster.name
}