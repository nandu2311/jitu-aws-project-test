

/* resource "null_resource" "bash_file_execution" {
    provisioner "file" {
        source = file("${script.sh}")
        destination = "/tmp/script.sh"        
    }
} */

resource "aws_instance" "my_task_checking" {
    ami = var.ami_id
    instance_type = "t2.micro"
    /* count = length(var.subnet_cidrs_public)  */
    subnet_id = aws_subnet.test-subnet[0].id
    key_name = var.key_pair_name
    associate_public_ip_address = true
    /* for_each = data.aws_subnet_ids.subnet_ids.ids
    subnet_id = each.value */
    vpc_security_group_ids = [ aws_security_group.test_security_group.id]
    user_data = "${file("script.sh")}"
    iam_instance_profile = aws_iam_instance_profile.iam_instance_profile.name

    tags = {
      "Name" = var.instance_name
    }

}