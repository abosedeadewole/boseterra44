#Create a iam role policy
resource "aws_iam_role_policy" "ssm_policy" {
  name = "ssm_policy"
  role = aws_iam_role.dev-resources-iam-role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = "${file("./iam-profile/ssm-policy.json")}"
}

# Create an IAM role
resource "aws_iam_role" "dev-resources-iam-role" {
name        = "dev-ssm-role"
description = "The role for the developer resources EC2"
assume_role_policy = "${file("./iam-profile/assume-policy.json")}"

inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["sts:AssumeRole"]
          Effect   = "Allow"
          Resource = ["${var.s3_iam_profile}"]
        },
      ]
    })

}
tags = {
stack = "SSM-Role"
}
}

resource "aws_iam_instance_profile" "dev-resources-iam-profile" {
name = "ec2_profile"
role = aws_iam_role.dev-resources-iam-role.name

}


resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
role       = aws_iam_role.dev-resources-iam-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy-test" {
role       = aws_iam_role.dev-resources-iam-role.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "dev-resources-s3-policy-full" {
role       = aws_iam_role.dev-resources-iam-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.dev-resources-iam-profile.name
}

#variable for s3-iam-bucket
variable "s3_iam_profile" {
  description = "value"
}

