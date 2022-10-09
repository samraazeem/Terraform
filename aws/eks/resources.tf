resource "aws_eks_cluster" "cluster" {
  name     = ""
  role_arn = "${data.aws_iam_role.role.arn}"
  version  = ""
  vpc_config {   
    subnet_ids = "${data.aws_subnet_ids.subnet.ids}"     
  }
}
