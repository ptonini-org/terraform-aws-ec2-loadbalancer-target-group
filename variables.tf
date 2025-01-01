variable "name" {
  default = null
}

variable "port" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "health_check" {
  type = object({
    enabled             = optional(bool, false)
    path                = optional(string)
    matcher             = optional(string)
    protocol            = optional(string, "HTTP")
    port                = optional(number)
    healthy_threshold   = optional(string)
    interval            = optional(string)
    timeout             = optional(string)
    unhealthy_threshold = optional(string)
  })
  default = {}
}

variable "target_type" {}

variable "target_ids" {
  type    = set(string)
  default = []
}

variable "autoscaling_groups" {
  type    = set(string)
  default = []
}

variable "listener_rules" {
  type = map(object({
    type = string
    listener_arn = string
    redirects = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = optional(string, "HTTP_301")
    }))
    conditions = map(object({
      host_header         = optional(set(string))
      path_pattern        = optional(set(string))
      http_request_method = optional(set(string))
      source_ip           = optional(set(string))
      http_header         = optional(map(string), {})
      query_string        = optional(map(string), {})
    }))
  }))
  default = {}
  nullable = false
}