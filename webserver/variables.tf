variable "SSH_CIDR_WEB_SERVER" {
    type = string
    default = "0.0.0.0/0"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-005fc0f236362e99f"
        us-east-2 = "ami-00eb69d236edcfaf8"
        us-west-2 = "ami-0b8c6b923777519db"
        eu-west-1 = "ami-0cdd3aca00188622e"
    }
}

variable "AWS_REGION" {
    type        = string
    default     = "us-east-2"
}

variable "ENVIRONMENT" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = "development"
}

variable "public_key_path" {
  description = "Public key path"
  default = "C:/Users/sambh/.ssh/webapp_key.pub"
}


variable "vpc_id" {
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
