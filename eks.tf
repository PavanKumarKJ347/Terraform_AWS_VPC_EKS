resource "aws_eks_cluster" "main" {
  name     = "${var.project}_${var.environment}_EKS_Cluster"
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.34"

  vpc_config {
    subnet_ids              = flatten([aws_subnet.public_subnets[*].id, aws_subnet.private_subnets[*].id])
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" : "${var.project}_${var.environment}_EKS_Cluster" }, var.common_tags)

  depends_on = [aws_iam_role_policy_attachment.cluster_role_policy_attachment]
}

resource "aws_iam_role" "cluster_role" {
  name               = "${var.project}_${var.environment}_EKS_Cluster_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge({ "Name" : "${var.project}_${var.environment}_EKS_Cluster_Role" }, var.common_tags)
}

resource "aws_iam_role_policy_attachment" "cluster_role_policy_attachment" {
  role       = aws_iam_role.cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project}_${var.environment}_EKS_Cluster_Node_Group"
  node_role_arn   = aws_iam_role.worker_role.arn
  depends_on      = [aws_iam_role_policy_attachment.worker_role_policy_attachment]

  subnet_ids = aws_subnet.private_subnets[*].id

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_minimum_size
    max_size     = var.node_group_maximum_size
  }

  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2023_x86_64_STANDARD"
  disk_size      = "20"
  capacity_type  = "ON_DEMAND"
  instance_types = [var.node_group_instance_type]
}

resource "aws_iam_role" "worker_role" {
  name               = "${var.project}_${var.environment}_EKS_Worker_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_nodes.json
  tags               = merge({ "Name" : "${var.project}_${var.environment}_EKS_Worker_Role" }, var.common_tags)
}

resource "aws_iam_role_policy_attachment" "worker_role_policy_attachment" {
  count      = length(var.worker_role_policies_arns)
  policy_arn = element(var.worker_role_policies_arns, count.index)
  role       = aws_iam_role.worker_role.name
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"

  depends_on = [aws_eks_node_group.eks_node_group]
}