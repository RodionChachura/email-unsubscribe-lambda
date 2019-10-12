variable "name" {
  default = "pomodoro-subscriber"
}

// for gateway.tf
variable "domain" {
  default = "pomodoro.increaser.org"
}

variable "zone_id" {
  default = "<YOUR_ROUTE_53_ZONE_ID>"
}

variable "certificate_arn" {
  default = "<YOUR_DOMAIN_CERTIFICATE_ARN>"
}

# if you use Sentry for errors reporting
variable "sentry_key" {
  default = "https://random_string@sentry.io/random_id"
}

# for cd.tf
variable "ci_container_name" {
  default = "api"
}

variable "repo_owner" {
  default = "RodionChachura"
}

variable "repo_name" {
  default = "pomodoro-subscriber"
}

variable "branch" {
  default = "master"
}
