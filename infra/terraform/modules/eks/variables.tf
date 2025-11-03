variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "EKS cluster VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "node_groups" {
  description = "EKS cluster node group config"
  type = map(
    object({
      instance_types = list(string)
      capacity       = string

      scaling_config = object({
        desired_size = number
        max_size     = number
        min_size     = number
      })
    })
  )
}
