resource "aws_iam_instance_profile" "kubernetes" {
  name = "kubernetes"
  role = aws_iam_role.kubernetes.name

}

resource "aws_iam_role" "kubernetes" {
  name               = "kubernetes"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    EOF

}

resource "aws_iam_role_policy_attachment" "kubernetes_policy_attach" {
  role       = aws_iam_role.kubernetes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"

}

resource "aws_iam_role_policy" "kubernetes_policy" {
  name   = "kubernetes_policy"
  role   = aws_iam_role.kubernetes.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3Access",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_name}"
      ]
    },
    {
      "Sid": "S3ObjectAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_name}/*"
      ]
    },
    {
      "Sid": "Route53Access",
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:GetChange"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}



# # iam user and group for kops
# resource "aws_iam_group" "kops_group" {
#   name = "kops"
# }

# resource "aws_iam_policy_attachment" "kops_policy_attachment_ec2" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
#   groups     = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_policy_attachment" "kops_policy_attachment_route53" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
#   groups     = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_policy_attachment" "kops_policy_attachment_s3" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   groups     = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_policy_attachment" "kops_policy_attachment_iam" {
#   policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
#   groups     = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_policy_attachment" "kops_policy_attachment_vpc" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
#   groups     = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_policy_attachment" "kops_policy_attachment_sqs" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
#   groups     = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_policy_attachment" "kops_policy_attachment_eventbridge" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
#   groups     = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_user" "kops_user" {
#   name = "kops"
# }

# resource "aws_iam_user_group_membership" "kops_group_membership" {
#   user    = aws_iam_user.kops_user.name
#   groups  = [aws_iam_group.kops_group.name]
# }

# resource "aws_iam_access_key" "kops_access_key" {
#   user = aws_iam_user.kops_user.name
# }