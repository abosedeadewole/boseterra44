resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = var.bucket-name 

  lifecycle_rule {
    id = "log"

    expiration {
      days = 90
    }

    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }


  tags = {
    Name        = "test-my-bucket"
    Environment = "test-env"
  }

}

data "template_file" "s3-bucket-policy" {
  template = "${file("./s3-bucket/bucket-policy.json")}"

  vars = {
    iam-role-arn = var.s3-iam-role # aws_iam_role.S3-Read-write-Role.arn
    resource-name = aws_s3_bucket.my-s3-bucket.arn
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  policy = data.template_file.s3-bucket-policy.rendered
} 
  



