# if you prefer to store the state on s3 uncomment block below and specify your values

# terraform {
#   backend "s3" {
#     bucket = "infrastructure-remote-state"
#     key    = "pomodoro/subscriber.tfstate"
#     region = "eu-central-1"
#   }
# }

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

