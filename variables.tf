## project variables

variable "project_name" {
    type = string
 
}

variable "environment_name" {
    type = string
  
}

variable "common_tags" {
    type = map
    
}

### vpc variables
variable "vpc_tags" {
    type = map
    default = {}
  
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

### igw variables

variable "aws_internet_gateway" {
  type = map
  default = {}
}

variable "vpc_id" {
    default = {}
  
}

## subnet variables

variable "public_subnet_cidrs" {
    type = list
    validation {
    condition = length(var.public_subnet_cidrs) == 2
    error_message = "please provide two public subnets CIDR"
    }
  
}

variable "public_subnet_cidr_tags" {
    type = map
  default = {}
}

variable "private_subnet_cidrs" {
    type = list
    validation {
    condition = length(var.private_subnet_cidrs) == 2
    error_message = "please provide two private subnets CIDR"
    }
  
}

variable "private_subnet_cidr_tags" {
    type = map
  default = {}
}

variable "database_subnet_cidrs" {
    type = list
    validation {
    condition = length(var.database_subnet_cidrs) == 2
    error_message = "please provide two database subnets CIDR"
    }
  
}

variable "database_subnet_cidr_tags" {
    type = map
  default = {}
}

variable "database_subnet_group_tags" {
    type = map
    default = {}
}

## natgateway tags

variable "nat_gateway_tags" {
    type = map
  default = {}
}

## route table tags

variable "public_route_table_tags"{
type = map
default = {}

}

variable "private_route_table_tags"{
type = map
default = {}

}

variable "database_route_table_tags"{
type = map
default = {}

}

### peering variable

variable "is_peering_required" {
    type = bool
    default = false
  
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
  
}

variable "vpc_peering_tags" {
    type = map
    default = {}
  
}