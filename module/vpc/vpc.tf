data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "web_infra_VPC" {
  cidr_block       = var.VPC_CIDR_BLOCK
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc" 
  }
}

resource "aws_subnet" "web_public_subnet_1" {
    vpc_id     = aws_vpc.web_infra_VPC.id
    cidr_block = var.PUB_CIDR_BLOCK_SUBNET_1
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = "true"
    tags = {
        Name = "${var.ENVIRONMENT}-web_public_subnet_1"
    }
}

resource "aws_subnet" "web_public_subnet_2" {
    vpc_id     = aws_vpc.web_infra_VPC.id
    cidr_block = var.PUB_CIDR_BLOCK_SUBNET_2
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = {
        Name = "${var.ENVIRONMENT}-web_public_subnet_2"
    }
}

resource "aws_subnet" "web_private_subnet_1" {
    vpc_id     = aws_vpc.web_infra_VPC.id
    cidr_block = var.PRIV_CIDR_BLOCK_SUBNET_1
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        Name = "${var.ENVIRONMENT}-web_private_subnet_1"
    }
}

resource "aws_subnet" "web_private_subnet_2" {
    vpc_id     = aws_vpc.web_infra_VPC.id
    cidr_block = var.PRIV_CIDR_BLOCK_SUBNET_2
    availability_zone = data.aws_availability_zones.available.names[1]
    tags = {
        Name = "${var.ENVIRONMENT}-web_private_subnet_2"
    }
}

resource "aws_internet_gateway" "web_infra_internet_gateway" {
    vpc_id = aws_vpc.web_infra_VPC.id

    tags = {
      Name = "${var.ENVIRONMENT}-web_infra_internet_gateway"
    }
  
}

resource "aws_eip" "web_infra_EIP_NAT" {
    domain = "vpc"
    depends_on = [ aws_internet_gateway.web_infra_internet_gateway]
}

resource "aws_nat_gateway" "web_infra_nat_gateway" {
    allocation_id = aws_eip.web_infra_EIP_NAT.id
    subnet_id = aws_subnet.web_public_subnet_1.id
    depends_on = [ aws_internet_gateway.web_infra_internet_gateway ]

    tags = {
      Name = "${var.ENVIRONMENT}-web_infra_nat_gateway"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.web_infra_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.web_infra_internet_gateway.id
    }

    tags = {
      Name = "${var.ENVIRONMENT}-web_public_infra_route_table"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.web_infra_VPC.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.web_infra_nat_gateway.id
    }
    
    tags = {
      Name = "${var.ENVIRONMENT}-web_private_infra_route_table"
    }
  
}

resource "aws_route_table_association" "to_public_subnet_1" {
    subnet_id = aws_subnet.web_public_subnet_1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "to_public_subnet_2" {
    subnet_id = aws_subnet.web_public_subnet_2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "to_private_subnet_1" {
    subnet_id = aws_subnet.web_private_subnet_1.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "to_private_subnet_2" {
    subnet_id = aws_subnet.web_private_subnet_2.id
    route_table_id = aws_route_table.private.id
}

provider "aws" {
  region = var.AWS_REGION
}

output "vpc_id" {
    value = aws_vpc.web_infra_VPC.id
}
output "public_subnet_1_id" {
    value = aws_subnet.web_public_subnet_1.id
}
output "public_subnet_2_id" {
    value = aws_subnet.web_public_subnet_2.id
}
output "private_subnet_1_id" {
    value = aws_subnet.web_private_subnet_1.id
}
output "private_subnet_2_id" {
    value = aws_subnet.web_private_subnet_2.id
}