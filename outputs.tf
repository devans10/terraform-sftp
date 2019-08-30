#-----------root/outputs.tf

#-----------storage_output.tf
output "Bucket_Name" {
  value = "${module.storage.bucketname}"
}

#-----------network/output.ft
output "Public_Subnets" {
  value = "${join(", ", module.networking.public_subnets)}"
}

output "Subnet_IPs" {
  value = "${join(", ", module.networking.subnet_ips)}"
}

output "Public_Security_Group" {
  value = "${module.networking.public_sg}"
}
