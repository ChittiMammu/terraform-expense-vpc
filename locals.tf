locals {
  resource_name = "${var.project_name}-${var.environment_name}"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}