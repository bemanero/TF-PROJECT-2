variable "instance_type" {

  description = "instance type"
  type        = string
}
variable "vpc_id" {
  type        = string
  description = "vpc ID number"
}
variable "subnet_id" {
  type        = string
  description = "subnet IDs"
}

variable "security_group_server" {
  type        = string
  description = "Server's security group"
}
variable "ami" {
  type        = string
  description = "(optional) describe your variable"
  default     = "ami-0e5f882be1900e43b"
}

variable "tags" {

}


variable "key_name" {
  description = "key name"
  type        = string

}
