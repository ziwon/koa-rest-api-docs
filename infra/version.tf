terraform {

  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.57.0"
  }

  backend "s3" {}
}
