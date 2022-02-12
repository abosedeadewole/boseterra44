# Create an IAM role
resource "aws_iam_role" "s3-assume-role" {
name        = "s3-assume-role"
description = "The role for the developer resources s3"
assume_role_policy = "${file("./iam-profile/s3-assume-policy.json")}"

tags = {
Name = "S3-IAm-Role"
}
}

resource "aws_iam_role_policy_attachment" "s3-full-access-policy" {
role       = aws_iam_role.s3-assume-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

}

output "aws_s3_assume_role_arn" {
  value = aws_iam_role.s3-assume-role.arn
}

