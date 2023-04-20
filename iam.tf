resource "aws_iam_role" "ec2_iam_role" {
    name = "ec2-iam-role-for-ec2-instance"
     assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
            }
        ]
    }
 EOF 
}

data "aws_iam_policy_document" "ec2_iam_policy_document" {
    /* bucket = aws_s3_bucket.webserver_s3_bucket.bucket */

    statement {

            sid = "editor1"
            effect = "Allow"
            actions = [ 
                "s3:GetObjectRetention",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectAttributes",
                "s3:ListBucket",
                "s3:GetObjectLegalHold",
                "s3:GetBucketAcl",
                "s3:GetObjectVersionAttributes",
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersion"
            ]

            resources = [ "${aws_s3_bucket.webserver_s3_bucket.arn}" ]


    }

     statement   {
        sid = "editor2"
        effect = "Allow"
        actions = [ "s3:ListAllMyBuckets"]
        resources = ["*"]
    }

    
  
}



resource "aws_iam_policy" "ec2-iam-policy" {
  name = "ec2-iam-access-policy"
  policy = data.aws_iam_policy_document.ec2_iam_policy_document.json
}

resource "aws_iam_policy_attachment" "policy-attachment" {
    name = "policy-attachment"
    roles = [ aws_iam_role.ec2_iam_role.name ]
    policy_arn = aws_iam_policy.ec2-iam-policy.arn
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
    name = "instance_iam_profile"
    role = aws_iam_role.ec2_iam_role.name
}