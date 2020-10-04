resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = ""
  node_role_arn  = "${data.aws_iam_role.node-role.arn}"
  subnet_ids    = ["${data.aws_subnet.node-subnet.id}"]
  disk_size     = "4"

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}