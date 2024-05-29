## project variables

variable "project_name" {
    type = string
 
}

variable "common_tags" {
    type = map
    default = {}
  
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