### vpc creation code

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = "main"
    }
  )
  }

#### igw code

  resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.aws_internet_gateway,
    {
      Name = "gw"
    }
  )
}
