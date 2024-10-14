module "web_infra_VPC" {
    source      = "./module/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
}

module "webApp_ag" {
    source      = "./webserver"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
    vpc_id = module.web_infra_VPC.vpc_id
    private_subnet_1_id = module.web_infra_VPC.private_subnet_1_id
    private_subnet_2_id = module.web_infra_VPC.private_subnet_2_id
    public_subnet_1_id = module.web_infra_VPC.public_subnet_1_id
    public_subnet_2_id = module.web_infra_VPC.public_subnet_2_id
}


output "load_balancer_output" {
  description = "Load Balancer"
  value       = module.webApp_ag.load_balancer_output
}