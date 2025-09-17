variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "final-vpc"
}

variable "repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "django-app-repo"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "final-eks-cluster"
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}
variable "github_pat" {
  description = "Personal Access Token для доступу до GitHub репозиторію"
  type        = string
  sensitive   = true
}

variable "github_user" {
  description = "GitHub username"
  type        = string
}

variable "github_repo_url" {
  description = "URL GitHub репозиторію"
  type        = string
}