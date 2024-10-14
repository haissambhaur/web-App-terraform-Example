variable "AWS_REGION" {
    default = "us-east-2"
}

variable "ENVIRONMENT" {
    description = "AWS VPC Environment Name"
    type        = string
    default = "dev"
}

variable "private_subnet_1_id" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}

variable "private_subnet_2_id" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}
variable "public_subnet_1_id" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}

variable "public_subnet_2_id" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}