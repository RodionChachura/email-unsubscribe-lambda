
# Only if the domain variable specified these resources will be created.
resource "aws_api_gateway_base_path_mapping" "api" {
  count = "${var.domain != "" ? 1 : 0}"
  api_id      = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.api.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.api.domain_name}"
}

resource "aws_api_gateway_domain_name" "api" {
  count = "${var.domain != "" ? 1 : 0}"
  certificate_arn = "${var.certificate_arn}"
  domain_name     = "${var.domain}"
}

resource "aws_route53_record" "api" {
  count = "${var.domain != "" ? 1 : 0}"
  name    = "${aws_api_gateway_domain_name.api.domain_name}"
  type    = "A"
  zone_id = "${var.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.api.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.api.cloudfront_zone_id}"
  }
}