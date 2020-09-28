resource "aws_s3_bucket" "demo" {
    bucket = "${var.tag}-${"bucket01"}"
    acl = "private"
    force_destroy= true
}

resource "aws_s3_bucket_object" "graphic" {
    bucket = aws_s3_bucket.demo.bucket
    key = "/graphic/batman.jpg"
    source = "~/batman.jpg"
}
