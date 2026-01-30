locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )
}

module "vpc" {
  source       = "./modules/vpc"
  environment  = var.environment
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  tags         = local.common_tags
}

module "iam" {
  source       = "./modules/iam"
  environment  = var.environment
  project_name = var.project_name
  tags         = local.common_tags
}

module "s3" {
  source       = "./modules/s3"
  environment  = var.environment
  project_name = var.project_name
  tags         = local.common_tags
}

module "ecr" {
  source       = "./modules/ecr"
  environment  = var.environment
  project_name = var.project_name
  tags         = local.common_tags
}

module "sagemaker" {
  source              = "./modules/sagemaker"
  environment         = var.environment
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.sagemaker_sg_id]
  execution_role_arn  = module.iam.sagemaker_execution_role_arn
  tags                = local.common_tags
}

module "glue" {
  source       = "./modules/glue"
  environment  = var.environment
  project_name = var.project_name
  role_arn     = module.iam.glue_role_arn
  data_bucket  = module.s3.data_bucket_name
  tags         = local.common_tags
}

module "stepfunctions" {
  source       = "./modules/stepfunctions"
  environment  = var.environment
  project_name = var.project_name
  role_arn     = module.iam.stepfunctions_role_arn
  tags         = local.common_tags
}

module "lambda" {
  source             = "./modules/lambda"
  environment        = var.environment
  project_name       = var.project_name
  role_arn           = module.iam.lambda_role_arn
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.lambda_sg_id]
  tags               = local.common_tags
}

module "monitoring" {
  source              = "./modules/monitoring"
  environment         = var.environment
  project_name        = var.project_name
  sagemaker_domain_id = module.sagemaker.domain_id
  tags                = local.common_tags
}
