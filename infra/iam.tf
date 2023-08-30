resource "aws_iam_role" "server" {
  name = "server-${data.aws_default_tags.current.tags.name}"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "server" {
  name = "server-${data.aws_default_tags.current.tags.name}"
  role = aws_iam_role.server.name
}

data "aws_iam_policy_document" "describe_instances" {
  statement {
    sid       = "DescribeInstances"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeInstances"
    ]
  }
}

resource "aws_iam_role_policy" "describe_instances" {
  name = "describe-instances-${data.aws_default_tags.current.tags.name}"
  role = aws_iam_role.server.id

  policy = data.aws_iam_policy_document.describe_instances.json
}
