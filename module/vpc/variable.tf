variable "VPC_CIDR_BLOCK" {
    description = "cidr block range for the vpc"
    type = string
    default = "10.0.0.0/16"
}

variable "ENVIRONMENT" {
    description = "environment value for VPC"
    type = string
    default = "dev"
}
variable "PUB_CIDR_BLOCK_SUBNET_1" {
    description = "cidr block range for public subnet 1"
    type = string
    default = "10.0.1.0/24"
}
variable "PUB_CIDR_BLOCK_SUBNET_2" {
    description = "cidr block range for public subnet 2"
    type = string
    default = "10.0.2.0/24"
}
variable "PRIV_CIDR_BLOCK_SUBNET_1" {
    description = "cidr block range for private subnet 1"
    type = string
    default = "10.0.20.0/24"
}
variable "PRIV_CIDR_BLOCK_SUBNET_2" {
    description = "cidr block range for private subnet 2"
    type = string
    default = "10.0.21.0/24"
}
variable "AWS_REGION" {
  default = "us-east-2"
}