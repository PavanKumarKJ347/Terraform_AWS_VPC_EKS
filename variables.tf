variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region Where Infrastructure Will be Created"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR for Virtual Private Cloud"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS Hostname for Virtual Private Cloud"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS Support for Virtual Private Cloud"
}

variable "common_tags" {
  type = map(string)
  default = {
    "Project"   = "Infrastructure"
    "Team"      = "Architect"
    "ManagedBy" = "Terraform"
  }
}

variable "project" {
  type        = string
  default     = "Amazon"
  description = "Project Name to be Used for VPC and EKS"
}

variable "environment" {
  type        = string
  default     = "Production"
  description = "Environment Name to be Used for VPC and EKS"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/18", "10.0.64.0/18"]
  description = "Public Subnets CIDRs for Virtual Private Cloud"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Map Public IP on Launch"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.128.0/18", "10.0.192.0/18"]
  description = "Private Subnets CIDRs for Virtual Private Cloud"
}

variable "worker_role_policies_arns" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
  description = "Worker Role Policies for ARNs"
}

variable "node_group_desired_size" {
  type        = number
  default     = 2
  description = "Desired Size for Node Group"
}

variable "node_group_minimum_size" {
  type        = number
  default     = 2
  description = "Minimum Size for Node Group"
}

variable "node_group_maximum_size" {
  type        = number
  default     = 5
  description = "Maximum Size for Node Group"
}

variable "node_group_instance_type" {
  type        = string
  default     = "t3.large"
  description = "Instance Type for Node Group"
}