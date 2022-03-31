module "ec2" {
     source = "./modules/ec2"
     vpc_security_group = [module.vpc.security_group_id]
     subnet_id = [module.vpc.public_subnet_id]
}
module "vpc" {
    source = "./modules/vpc"
}

module "rds" {
    source = "./modules/rds"
    vpc_id = [module.vpc.vpc_id]
    db_subnet_group = [module.vpc.db_subnet_group]
}