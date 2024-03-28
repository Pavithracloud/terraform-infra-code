variable "ProjectName" {
  type    = string
}

variable "environment" {
    type = string
  }

  variable "vpc_id" {
    type = string
  }

  variable "ingress_ports" {
    type = list(string)
  }
  variable "cidr_blocks" {
    type = list
    default = []
  }
  variable "security_groups_id" {
    type = list
    default = []
  }
  variable "resource_name" {
    type = string
  }