data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"

  source {
    content  = <<EOF
import json

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Model evaluation completed')
    }
EOF
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "evaluate" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "${var.project_name}-${var.environment}-evaluate"
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.11"
  timeout          = 300

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = var.tags
}

resource "aws_lambda_function" "data_validation" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "${var.project_name}-${var.environment}-data-validation"
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.11"
  timeout          = 300

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = var.tags
}
