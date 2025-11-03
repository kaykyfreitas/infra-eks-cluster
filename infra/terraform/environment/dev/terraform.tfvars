backend_bucket_name = "aws-bucket-name"

repository_name = "infra-eks-cluster"

environment = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidr = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

private_subnet_cidr = [
  "10.0.4.0/24",
  "10.0.5.0/24",
  "10.0.6.0/24"
]

region = "us-east-1"

availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c",
]

eks_cluster_name = "my-eks-cluster"

cluster_version = "1.34"

node_groups = {
  default = {
    instance_types = ["t3.medium"]
    capacity       = "SPOT"

    scaling_config = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
    }
  }
}
