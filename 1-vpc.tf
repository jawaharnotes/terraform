#defining the data source to fetch the details from AWS VPC , provided the Aws_VPC id
data "aws_vpc" "main" {
  id = "vpc-077d19ad2612c7fa0"
}

#Defining Output , so output can be utlised in another module or definition

output "vpc_cidr" {
    value = data.aws_vpc.main.cidr_block 
}
