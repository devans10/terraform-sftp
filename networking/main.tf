#-------networking/main.tf-------

data "aws_availability_zones" "available" {}

resource "aws_vpc" "tf_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = "${aws_vpc.tf_vpc.id}"
}

resource "aws_route_table" "tf_public_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf_internet_gateway.id}"
  }
}

resource "aws_default_route_table" "tf_private_rt" {
  default_route_table_id = "${aws_vpc.tf_vpc.default_route_table_id}"
}

resource "aws_subnet" "tf_public_subnet" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "${var.public_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_route_table_association" "tf_public_assoc" {
  subnet_id      = "${aws_subnet.tf_public_subnet.id}"
  route_table_id = "${aws_route_table.tf_public_rt.id}"
}

resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.tf_vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "sftp" {
  vpc_id = "${aws_vpc.tf_vpc.id}"
  service_name = "com.amazonaws.${var.aws_region}.transfer.server"
  vpc_endpoint_type = "Interface"
  subnet_ids = ["${aws_subnet.tf_public_subnet.id}"]
  security_group_ids = ["${aws_security_group.tf_public_sg.id}"]
}

resource "aws_lb" "sftp_lb" {
  name               = "sftp-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.tf_public_subnet.id}"]

}

resource "aws_lb_target_group" "sftp_lb_tg" {
  name     = "tf-sftp-lb-tg"
  port     = 22
  protocol = "TCP"
  vpc_id   = "${aws_vpc.tf_vpc.id}"
}

resource "aws_lb_target_group_attachment" "sftp_lb_tga" {
  target_group_arn = "${aws_lb_target_group.sftp_lb_tg.arn}"
  target_id = "${aws_vpc_endpoint.sftp.id}"
  port = 22
}
