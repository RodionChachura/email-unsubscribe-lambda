variable "name" {
  default = "pomodoro-subscriber"
}

# OPTIONAL:

# if you use Sentry for errors reporting
variable "sentry_key" {}

// if you have a domain
variable "domain" {}
variable "zone_id" {}
variable "certificate_arn" {}


# if you want to use AWS CodePipeline for CD
variable "ci_container_name" {}
variable "repo_owner" {}
variable "repo_name" {}
variable "branch" {}
