variable name {}

locals {
  name                = "${var.name}"
  timestamp           = "${timestamp()}"
  timestamp_sanitized = "${replace("${local.timestamp}", "/[-| |t|z|:]/", "")}"
  build_date          = "${substr(local.timestamp_sanitized, 0, 8)}"
}

output "name" {
  value = "${local.name}"
}

output "build_time" {
  value = "${local.timestamp_sanitized}"
}

output "build_date" {
  value = "${local.build_date}"
}
