variable "region" {
  description = " provider region"
  type        = string
  default     = "eu-west-2"
}
variable "project_name" {
  type        = string
  description = "project name"
  default     = "TERRAFORM-P2"
}
variable "vpc_cidr" {
  description = "Value of cidr block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tenancy" {
  description = "instance tenancy for the VPC"
  type        = string
  default     = "default"
}
variable "exclude_names" {
  description = "names to me excluded"
  type        = string
  default     = "eu-west-2c"
}
variable "subnet_names" {
  description = "subnets names for the VPC"
  type        = list(string)
  default     = ["web-public-1", "web-public-2", "app-private-1", "app-private-2"]
}

variable "subnet_cidr_block" {
  description = "Value of cidr block for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}


variable "public_access" {
  description = "public access cidr block"
  type        = string
  default     = "0.0.0.0/0"
}
variable "local_access" {
  description = "local access"
  type        = string
  default     = "local"
}


#servers variables -------------------------------------------------------------------------
variable "instance_type" {
  type        = string
  description = "ec2 instance type"
  default     = "t2.micro"
}
variable "ami" {
  type        = string
  description = "EC2 images"
  default     = "ami-0e5f882be1900e43b"
}



variable "key_name" {
  description = "key name"
  type        = string
  default     = "t2_key_pair"
}
variable "servername" {

  description = "server names"

  type    = list(string)
  default = ["web-server-1", "web-server-2", "app-server-1", "app-server-2"]

}
#db_security group-----------------------------------------------------------------------------
variable "ingress-protocol" {
  description = "network ingress protocol"
  type        = string
  default     = "tcp"
}
variable "egress-protocol" {
  description = "network egress protocol"
  type        = string
  default     = "-1"
}