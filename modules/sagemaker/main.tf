resource "aws_sagemaker_domain" "main" {
  domain_name = "${var.project_name}-${var.environment}"
  auth_mode   = "IAM"
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids

  default_user_settings {
    execution_role  = var.execution_role_arn
    security_groups = var.security_group_ids
  }

  tags = var.tags
}

resource "aws_sagemaker_user_profile" "main" {
  domain_id         = aws_sagemaker_domain.main.id
  user_profile_name = "default-user"

  tags = var.tags
}

resource "aws_sagemaker_model_package_group" "main" {
  model_package_group_name = "${var.project_name}-${var.environment}-model-group"

  tags = var.tags
}

resource "aws_sagemaker_feature_group" "main" {
  feature_group_name = "${var.project_name}-${var.environment}-features"
  record_identifier_feature_name = "record_id"
  event_time_feature_name        = "event_time"
  role_arn                       = var.execution_role_arn

  online_store_config {
    enable_online_store = true
  }

  offline_store_config {
    s3_storage_config {
      s3_uri = "s3://${var.project_name}-${var.environment}-data-${data.aws_caller_identity.current.account_id}/feature-store"
    }
  }

  feature_definition {
    feature_name = "record_id"
    feature_type = "String"
  }

  feature_definition {
    feature_name = "event_time"
    feature_type = "String"
  }

  tags = var.tags
}

data "aws_caller_identity" "current" {}
