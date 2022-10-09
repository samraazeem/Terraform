data "aws_vpc" "selected" {
  tags = {
    Name = "${var.vpc}"
  }
}
data "aws_subnet_ids" "subnet" {
  vpc_id = "${data.aws_vpc.selected.id}"
}

data "aws_iam_role" "role" {
  name = "${var.cluster-service-role}"
}

data "aws_iam_role" "node-role" {
  name = "${var.node-role}"
}

data "aws_subnet" "node-subnet" {
  tags = {
	Name = "${var.node-subnet}"
}
}