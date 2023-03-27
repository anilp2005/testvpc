############################################AWS_VPC#############################################
#-------------------------------
# AWS Provider
#-------------------------------
provider "aws" {
  region = "us-east-1"
}
 
#-------------------------------
# VPC resource
#-------------------------------
resource "aws_vpc" "Corp-Network-n-virginia" {
    cidr_block = "10.102.1.0/24"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"    
    
    tags {
        Name = "Corp-Network-n-virginia"
    }
}
########################### Create Subnet ##################################
resource "aws_subnet" "corp-nw-public" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "corp-nw-public ${count.index + 1}"
 }
}
 
resource "aws_subnet" "corp-nw-private" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "corp-nw-private ${count.index + 1}"
 }
}
############### Variables for Subnets #################
variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.102.1.1/27", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
       }
