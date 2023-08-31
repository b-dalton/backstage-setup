resource "aws_key_pair" "server" {
  key_name   = "key-${data.aws_default_tags.current.tags.Name}"
  public_key = var.backstage_server_public_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "backstage" {
  count                       = var.num_servers
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.medium"
  iam_instance_profile        = aws_iam_instance_profile.server.name
  subnet_id                   = aws_subnet.public[count.index].id
  key_name                    = aws_key_pair.server.key_name
  vpc_security_group_ids      = [aws_security_group.backstage.id]
  associate_public_ip_address = true
}

resource "aws_ebs_volume" "backstage" {
  availability_zone = "eu-west-2a"
  size              = 10
}

resource "aws_volume_attachment" "backstage" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.backstage.id
  instance_id = aws_instance.backstage[0].id
}

resource "aws_security_group" "backstage" {
  vpc_id = aws_vpc.main.id
  name   = "${data.aws_default_tags.current.tags.Name}-sg"
}

resource "aws_security_group_rule" "allow_ssh_server" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backstage.id
}

resource "aws_security_group_rule" "allow_egress_server" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backstage.id
}