data "aws_caller_identity" "current" {}

resource "aws_vpc_endpoint" "my_vpeendpoint" {
    vpc_id = aws_vpc.test-env.id
    service_name = "com.amazonaws.${var.aws_region}.s3"
    vpc_endpoint_type = "Gateway"
    /* security_group_ids = [ "${aws_security_group.test_security_group.id}" ] */
    /* private_dns_enabled = true */
    /* route_table_ids = [ aws_route_table.test_route_table.id ] */
    /* subnet_ids = [ aws_subnet.test-subnet[count.index].id ] */
    /* count = length(var.subnet_cidrs_public) */

}

resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint_rt_associate" {
    /* count = length(var.availability_zones) */
    /* subnet_ids = [ aws_subnet.test-subnet[count.index].id ]  */
    count = length(var.subnet_cidrs_public)
    route_table_id = aws_route_table.test_route_table.id
    vpc_endpoint_id = aws_vpc_endpoint.my_vpeendpoint.id
  
}


data "aws_prefix_list" "vpce_prefix_list" {
    prefix_list_id = aws_vpc_endpoint.my_vpeendpoint.prefix_list_id
  
}

resource "aws_s3_bucket" "webserver_s3_bucket" {
    bucket = "simple-website-testing-vpcendpoint"

    tags = {
      "Name" = "MyBucket"
    }
}

/* resource "aws_s3_bucket_policy" "allow_access_to_specific_vpce_only" {
    bucket = aws_s3_bucket.webserver_s3_bucket.id

    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "Access-to-specific-VPCE-only",
        "Principal": "*",
        "Action": "s3:*",
        "Effect": "Allow",
        "Resource": [
            aws_s3_bucket.webserver_s3_bucket.arn,
            "${aws_s3_bucket.webserver_s3_bucket.arn}/*",],
        "Condition": {
            "StringNotEquals": {
            "aws:SourceVpce": "${aws_vpc_endpoint.my_vpeendpoint.id}",
            }
        }
        
     }
    ]
  })
} */

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership" {
    bucket = aws_s3_bucket.webserver_s3_bucket.id
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.webserver_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



data "aws_iam_policy_document" "mybucket_policy" {
    /* bucket = aws_s3_bucket.webserver_s3_bucket.bucket */

    statement {

            principals {
              type = "AWS"
              identifiers = ["*"]
            }

            actions = [ 
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetObject"
            ]

            resources = [ 
                aws_s3_bucket.webserver_s3_bucket.arn,
                "${aws_s3_bucket.webserver_s3_bucket.arn}/*",
            ]

            condition {
            test     = "StringEquals"
            variable = "aws:sourceVpce"
            values   = [ aws_vpc_endpoint.my_vpeendpoint.id ]
            }

    }
    
  
}

resource "aws_s3_bucket_policy" "s3_bucket_policy_attachment" {
    bucket = aws_s3_bucket.webserver_s3_bucket.id
    policy = data.aws_iam_policy_document.mybucket_policy.json
}

