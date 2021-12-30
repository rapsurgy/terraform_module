variable "name_of_resource_group" {
    type = any
    /*default = "Terraform"*/
    description = "name of resource group"
}

variable "location" {
    type = any
    /*default= "West Europe"*/
    description = "location of resource group"
}

variable "nsg_name" {
    type = any
    /*default= "West Europe"*/
    description = "name of network security group"
}

variable "dns_server" {
    type = any
    /*default= "West Europe"*/
    description = "name of DNS server"
}