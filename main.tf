provider "aws" {
  region = "${var.aws_region}"
}

#terraform {
#  backend "s3" {
#    bucket = "la-terraform-course-state-awo4er209348r"
#    key = "terraform/terraform.tfstate"
#    region = "us-east-1"
#  }
#}
# Deploy Storage Resource
module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

# Deploy networking Resources

module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidr = "${var.public_cidr}"
  accessip     = "${var.accessip}"
  aws_region  = "${var.aws_region}"
}

#module "sftp" {
#  source      = "./sftp"
#  sftp_endpoint_id      = "${module.networking.sftp_endpoint_id}"
#}
# Deploy compute resources

#module "compute" {
#  source          = "./compute"
#  instance_count  = "${var.instance_count}"
#  key_name        = "${var.key_name}"
#  public_key_path = "${var.public_key_path}"
#  instance_type   = "${var.server_instance_type}"
#  subnets         = "${module.networking.public_subnets}"
#  security_group  = "${module.networking.public_sg}"
#  subnet_ips      = "${module.networking.subnet_ips}"
#}
