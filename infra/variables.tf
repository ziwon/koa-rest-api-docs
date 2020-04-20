variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "vpc_id" {
  type = string
}

variable "project" {
  description = "The prefix of application. ex) ziwon-koa-rest-api"
  type        = string
  default     = "ziwon"
}

variable "app" {
  type    = string
  default = "rest-api"
}

# dev | prod
variable "environment" {
  type    = string
  default = "dev"
}

variable "service_replicas" {
  type    = number
  default = 1
}

variable "task_definition" {
  type = object({
    cpu             = number
    memory          = number
    container_name  = string
    container_image = string
    container_port  = number
  })
  default = {
    cpu             = 128
    memory          = 256
    container_name  = "app"
    container_image = "ziwon/go_app"
    container_port  = 8080
  }
}

variable "certificate_arn" {
  type = string
}

variable "kms_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
