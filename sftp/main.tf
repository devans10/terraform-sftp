resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type = "VPC_ENDPOINT"
  endpoint_details {
      vpc_endpoint_id = "${var.sftp_endpoint_id}"
  }

  tags = {
    NAME = "tf-acc-test-transfer-server"
    ENV = "test"
  }
}


resource "aws_iam_role" "sftp_iam_role" {
  name = "tf-test-transfer-user-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "sftp_role_policy" {
  name = "tf-test-transfer-user-iam-policy"
  role = "${aws_iam_role.sftp_iam_role.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_transfer_user" "sftp_user" {
  server_id = "${aws_transfer_server.sftp_server.id}"
  user_name = "tftestuser"
  role      = "${aws_iam_role.sftp_iam_role.arn}"
}

