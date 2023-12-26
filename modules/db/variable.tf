variable "vpc_cidr_block" {
  description = "Value of cidr block for the VPC"
  type        = string
}

variable "public_access" {
  description = "public access cidr block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allocation-storage" {
  description = "Allocation storage"
  type        = number
  default     = "10"
}
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydb"
}

variable "db_subnet_group_name" {
  description = "Database name"
  type        = string

}
variable "db_engine" {
  description = "Database Engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {

  description = "database engine vesion"
  type        = string
  default     = "8.0.35"
}

variable "instance_class" {
  description = "database instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "username" {

  description = "username"
  type        = string
  default     = "Emmanuel"
}

variable "password" {
  description = "Password to access database"
  type        = string
  default     = "i-am-an-engineer"
}

variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = "default.mysql8.0"

}

variable "skip_final_snapshot" {
  description = "skip final snapshot"
  type        = bool
  default     = true

}
variable "db_sg" {
  type        = string
  description = "DATABASE SECURITY GROUP"
}