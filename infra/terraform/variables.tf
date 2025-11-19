variable "backend_bucket_name" {
  description = "Terraform backend AWS bucket name"
  type = string
}

variable "repository_name" {
  description = "Git repository name"
  type = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = list(string)
}

variable "availability_zone" {
  description = "Availability zones"
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
      ami_type       = string

      scaling_config = object({
        desired_size = number
        max_size     = number
        min_size     = number
      })
    })
  )
}
