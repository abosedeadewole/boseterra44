
resource "aws_s3_bucket" "metadata-s3" {
  bucket = "metadata-ayo"
  acl    = "private"
  
  tags = {
    Name        = "My bucket"
    Environment = "Test"
  }
}


resource "aws_s3_bucket_object" "sample_object" {
  bucket = aws_s3_bucket.metadata-s3.bucket
  key    = "test.txt"
  source = "./s3/test.txt"
  etag   = filemd5("./s3/test.txt")
}

/*
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.metadata-s3.id
  policy = "${file("./s3/s3-allow-access-policy.json")}"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.metadata-s3.id
  policy = data.template_file.task_01.rendered
}


data "template_file" "task_01" {
  template = "${file("./s3/s3-allow-access-policy.json")}"

  vars {
    arn = "var.aws_arn_dev_role"
  }
}

variable "aws_arn_dev_role" {
  description = "value"
}
*/