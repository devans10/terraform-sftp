#-------networking/outputs.tf-------
output "public_subnets" {
  value = "${aws_subnet.tf_public_subnet.*.id}"
}

output "public_sg" {
  value = "${aws_security_group.tf_public_sg.id}"
}

output "subnet_ips" {
  value = "${aws_subnet.tf_public_subnet.*.cidr_block}"
}

output "vpc_id" {
  value = "${aws_vpc.tf_vpc.id}"
}

output "sftp_endpoint_id" {
  value = "${aws_vpc_endpoint.sftp.id}"
}

output "sftp_lb_tg_id" {
  value = "${aws_lb_target_group.sftp_lb_tg.id}"
}
