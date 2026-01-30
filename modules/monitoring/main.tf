resource "aws_cloudwatch_log_group" "sagemaker" {
  name              = "/aws/sagemaker/${var.project_name}-${var.environment}"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-${var.environment}-alerts"

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "sagemaker_endpoint_invocations" {
  alarm_name          = "${var.project_name}-${var.environment}-endpoint-invocations"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ModelInvocations"
  namespace           = "AWS/SageMaker"
  period              = 300
  statistic           = "Sum"
  threshold           = 1000
  alarm_description   = "This metric monitors SageMaker endpoint invocations"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    EndpointName = "${var.project_name}-${var.environment}-endpoint"
  }

  tags = var.tags
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/SageMaker", "ModelInvocations"]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.name
          title  = "SageMaker Model Invocations"
        }
      }
    ]
  })
}

data "aws_region" "current" {}
