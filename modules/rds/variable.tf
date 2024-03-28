variable "ProjectName" {
    type = string
  
}
variable "environment" {
    type = string
  
}
variable "subnet_name" {
    type = string
    description = "public and private"
  
}
variable "db_parameter_group_name" {
    type = string
    default = "postgres"
}
variable "instance_class" {
    type = string
    description = "t2 or anytype"
}
variable "rds_username" {
    type = string 
}
variable "security_groups_id" {
    type = list(string)
  
}

variable "db_name" {
    type = string
  
}
  

variable "deletion_protection" {
  type = bool
}

variable "password" {
  type = string
}


variable "subnet_id" {
  type = list
}

variable "publicly_accessible" {
      type=bool 
}

variable "backup_retention_period" {
    type = number
    description = "Describe the backup retention period"
}      

variable "auto_minor_version_upgrade" {
type = bool
}

variable "max_allocated_storage" {
    type = number
       
}

variable "allocated_storage" {

    type = number
  
}