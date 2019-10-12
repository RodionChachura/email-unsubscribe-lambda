resource "aws_s3_bucket" "lambdas_storage" {
  bucket = "tf-${var.name}-storage"
}

data "archive_file" "local_zipped_lambda" {
  type        = "zip"
  source_dir = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_s3_bucket_object" "zipped_lambda" {
  bucket = "${aws_s3_bucket.lambdas_storage.bucket}"
  key    = "lambda.zip"
  source = "${data.archive_file.local_zipped_lambda.output_path}"
}

resource "aws_lambda_function" "api" {
  function_name = "tf-${var.name}"

  s3_bucket = "${aws_s3_bucket.lambdas_storage.bucket}"
  s3_key    = "${aws_s3_bucket_object.zipped_lambda.key}"

  handler     = "src/lambda.handler"
  runtime     = "nodejs8.10"
  timeout     = "50"
  memory_size = "1600"
  role        = "${aws_iam_role.api.arn}"
  environment {
    variables = {
      SENTRY_KEY = "${var.sentry_key}"
    }
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name = "tf-${var.name}"
}

resource "aws_iam_policy" "api" {
  name = "tf-${var.name}"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:*",
        "logs:*",
        "s3:*",
        "ses:*",
        "cloudfront:*",
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "api" {
  name = "tf-${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api" {
  name = "tf-${var.name}"
  role = "${aws_iam_role.api.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "api" {
  role       = "${aws_iam_role.api.name}"
  policy_arn = "${aws_iam_policy.api.arn}"
}
