
provider "aws" {
  profile = "terraform-admin"
  region = "ap-south-1"
}

terraform {
  required_version = ">= 1.0"            #Terraform version needs to be greater than or equal to  1.0
  
  required_providers {
    aws = {                              # Terraform plugin name - AWS , which knows to speak to AWS 
        source  = "hashicorp/aws"
        version = "~> 5.94"              #It will accept from 5.94 to 5.99 but not 6.00. This is aws provider 
                                         # version from hashicorp/aws . It is NOT  AWS version . 
                                         #If not mentioned, Terraform will update some latest version, which can break prod  
    }
  }
}