module "dev_vpc" {

  source         = "./modules/vpc"
  cidr_block     = var.cidr_block
  pri_sub_1_cidr = var.pri_sub_1_cidr
  pri_sub_2_cidr = var.pri_sub_2_cidr
  pub_sub_1_cidr = var.pub_sub_1_cidr
  pub_sub_2_cidr = var.pub_sub_2_cidr
  ProjectName    = var.ProjectName
  environment    = var.environment
  region         = var.region

}

# VPC Variables
variable "ProjectName" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "pri_sub_1_cidr" {
  type = string

}

variable "pri_sub_2_cidr" {
  type = string

}
variable "pub_sub_1_cidr" {
  type = string

}
variable "pub_sub_2_cidr" {
  type = string

}

variable "region" {
  type = string
}

variable "access_key" {
type=string
}

variable "secret_key" {
type=string
}
