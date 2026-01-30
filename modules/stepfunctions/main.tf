resource "aws_sfn_state_machine" "ml_pipeline" {
  name     = "${var.project_name}-${var.environment}-ml-pipeline"
  role_arn = var.role_arn

  definition = jsonencode({
    Comment = "ML Pipeline Orchestration"
    StartAt = "DataPreprocessing"
    States = {
      DataPreprocessing = {
        Type     = "Task"
        Resource = "arn:aws:states:::glue:startJobRun.sync"
        Parameters = {
          JobName = "${var.project_name}-${var.environment}-etl-job"
        }
        Next = "TrainModel"
      }
      TrainModel = {
        Type     = "Task"
        Resource = "arn:aws:states:::sagemaker:createTrainingJob.sync"
        Parameters = {
          TrainingJobName = "training-job"
          RoleArn         = var.role_arn
          AlgorithmSpecification = {
            TrainingImage     = "382416733822.dkr.ecr.ap-south-1.amazonaws.com/xgboost:latest"
            TrainingInputMode = "File"
          }
          InputDataConfig = [{
            ChannelName = "training"
            DataSource = {
              S3DataSource = {
                S3DataType = "S3Prefix"
                S3Uri      = "s3://bucket/data"
              }
            }
          }]
          OutputDataConfig = {
            S3OutputPath = "s3://bucket/output"
          }
          ResourceConfig = {
            InstanceType   = "ml.m5.xlarge"
            InstanceCount  = 1
            VolumeSizeInGB = 30
          }
          StoppingCondition = {
            MaxRuntimeInSeconds = 3600
          }
        }
        Next = "EvaluateModel"
      }
      EvaluateModel = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = "${var.project_name}-${var.environment}-evaluate"
        }
        End = true
      }
    }
  })

  tags = var.tags
}
