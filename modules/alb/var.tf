variable "ProjectName" {
  type    = string
}

variable "environment" {
    type = string
  }


  variable "security_groups_id" {
    type = list(string)
  }
  variable "pub_subnet_id" {
    type = list
  }
  
  variable "vpc_id" {
    type = string
  }











