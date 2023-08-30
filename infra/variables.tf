variable "region" {
  default = "eu-west-2"
  type    = string
}

variable "num_servers" {
  default = 1
  type    = number
}

variable "num_subnets_public" {
  default = 1
  type    = number
}

variable "backstage_server_public_key" {
  type = string
}