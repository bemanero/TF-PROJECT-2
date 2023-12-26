region            = "eu-west-2"
project_name      = "Website"
vpc_cidr          = "10.0.0.0/16"
tenancy           = "default"
subnet_names      = ["pub_sub_cidr1", "pub_sub_cidr2", "priv_app_sub_cidr1", "priv_app_sub_cidr2"]
subnet_cidr_block = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
instance_type     = "t2.micro"
