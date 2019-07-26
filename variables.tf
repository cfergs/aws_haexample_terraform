/*
Customize the below to suit your requirements. You should not be directly modifying other tf files.
*/

variable "region" {
  description = "Region where infrastructure will be built"
  default     = "ap-southeast-2"
}

variable "credentials_file" {
  description = "Location of your credentials file"
  default     = "./credentials"
}

variable "vpc_cidr_block" {
  description = "Top level IP range for your VPC. All other subnets reside in this block. Express with the subnet mask"
  default     = "10.200.0.0/20"
}

variable "zones" {
  description = "name and public/private IP ranges for availability zones"
  default = [
    {
      name            = "zone1"
      public_subnet   = "10.200.0.0/24"
      private_subnet  = "10.200.2.0/23"
    },
    {
      name            = "zone2"
      public_subnet   = "10.200.1.0/24"
      private_subnet  = "10.200.4.0/23"
    },
  ]
}

variable "ami_instance_size" {
  description = "size of instances"
  default     = "t2.micro"
}
