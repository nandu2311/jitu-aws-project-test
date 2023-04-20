
output "s3-bucket-details" {
    value = aws_s3_bucket.webserver_s3_bucket.bucket
}

/* output "subnet_cidr_blocks" {
    value = ["${data.aws_subnet.subnet_list.*.cidr_block}"]
  
} */

output "instance_public_ip" {
    value = aws_instance.my_task_checking.public_ip
}

  