


# Production-Grade MLOps Infrastructure with Terraform

A comprehensive, modular Terraform infrastructure for production-level Machine Learning Operations (MLOps) on AWS. This setup provides end-to-end ML pipeline infrastructure including data processing, model training, deployment, and monitoring.

## 🏗️ Architecture Overview

This infrastructure provisions:

- **Networking**: VPC with public/private subnets, NAT Gateway, Internet Gateway
- **Data Storage**: S3 buckets for data, models, and artifacts with versioning and encryption
- **ML Platform**: SageMaker Domain, Feature Store, Model Registry
- **Data Processing**: AWS Glue for ETL jobs, crawlers, and data catalog
- **Orchestration**: Step Functions for ML pipeline workflow
- **Compute**: Lambda functions for data validation and model evaluation
- **Container Registry**: ECR for custom ML container images
- **Monitoring**: CloudWatch logs, metrics, alarms, and dashboards
- **Security**: IAM roles with least privilege access

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Module Structure](#module-structure)
- [Quick Start](#quick-start)
- [Environment Configuration](#environment-configuration)
- [Deployment](#deployment)
- [Infrastructure Components](#infrastructure-components)
- [Best Practices](#best-practices)
- [Cost Optimization](#cost-optimization)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

1. **Terraform** >= 1.5.0
   - [Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

2. **AWS CLI** >= 2.0
   ```bash
   aws --version
   ```

3. **AWS Account** with appropriate permissions

### AWS Credentials Setup

Configure AWS credentials locally:

```bash
aws configure
AWS Access Key ID [None]: <YOUR_ACCESS_KEY>
AWS Secret Access Key [None]: <YOUR_SECRET_KEY>
Default region name [None]: ap-south-1
Default output format [None]: json
```

### Required IAM Permissions

Your AWS user/role needs permissions for:
- VPC, Subnets, Security Groups
- S3, IAM, ECR
- SageMaker, Glue, Step Functions, Lambda
- CloudWatch, SNS

## Installation

### 1. Clone Repository

```bash
git clone https://github.com/dataopslabs-aws/aws-dugb-sagemaker-tfsetup.git
cd aws-dugb-sagemaker-tfsetup
```

### 2. Initialize Terraform

```bash
terraform init
```

This will:
- Download required providers
- Initialize backend configuration
- Prepare modules

## Module Structure

```
.
├── main.tf                 # Root module orchestration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── provider.tf             # Provider configuration
├── backend.tf              # Remote state configuration
├── modules/
│   ├── vpc/               # Network infrastructure
│   ├── iam/               # IAM roles and policies
│   ├── s3/                # S3 buckets for data/models
│   ├── sagemaker/         # SageMaker domain and features
│   ├── glue/              # Data processing jobs
│   ├── stepfunctions/     # ML pipeline orchestration
│   ├── lambda/            # Serverless functions
│   ├── ecr/               # Container registry
│   └── monitoring/        # CloudWatch monitoring
└── environments/
    ├── dev/               # Development environment
    ├── staging/           # Staging environment
    └── prod/              # Production environment
```

## Quick Start

### Deploy Development Environment

```bash
# Review the plan
terraform plan -var-file="environments/dev/terraform.tfvars"

# Apply the configuration
terraform apply -var-file="environments/dev/terraform.tfvars"
```

### Deploy Production Environment

```bash
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## Environment Configuration

Each environment has its own configuration file:

### Development (`environments/dev/terraform.tfvars`)
- Minimal resources
- Cost-optimized instance types
- Shorter retention periods

### Staging (`environments/staging/terraform.tfvars`)
- Production-like setup
- Testing and validation
- SOC2 compliance tags

### Production (`environments/prod/terraform.tfvars`)
- High availability
- Enhanced monitoring
- Backup and disaster recovery
- Full compliance tags

## Deployment

### Step-by-Step Deployment

1. **Validate Configuration**
   ```bash
   terraform validate
   ```

2. **Format Code**
   ```bash
   terraform fmt -recursive
   ```

3. **Plan Infrastructure**
   ```bash
   terraform plan -var-file="environments/dev/terraform.tfvars" -out=tfplan
   ```

4. **Review Plan**
   - Check resources to be created
   - Verify configurations
   - Estimate costs

5. **Apply Changes**
   ```bash
   terraform apply tfplan
   ```

6. **Verify Outputs**
   ```bash
   terraform output
   ```

## Infrastructure Components

### 1. VPC Module
- Multi-AZ deployment
- Public and private subnets
- NAT Gateway for outbound traffic
- Security groups for SageMaker and Lambda

### 2. S3 Module
- **Data Bucket**: Raw and processed data
- **Model Bucket**: Trained models and artifacts
- **Artifacts Bucket**: Pipeline artifacts
- Features: Versioning, encryption, public access blocking

### 3. SageMaker Module
- SageMaker Domain for Studio
- User profiles
- Model Package Groups
- Feature Store (online/offline)

### 4. Glue Module
- Data Catalog database
- Crawlers for schema discovery
- ETL jobs for data transformation
- Workflow orchestration

### 5. Step Functions Module
- ML pipeline state machine
- Orchestrates: Data preprocessing → Training → Evaluation
- Integration with Glue, SageMaker, Lambda

### 6. Lambda Module
- Model evaluation function
- Data validation function
- VPC-enabled for secure access

### 7. ECR Module
- Container image repository
- Image scanning enabled
- Lifecycle policies

### 8. Monitoring Module
- CloudWatch Log Groups
- Metric alarms
- SNS topics for alerts
- Custom dashboards

## Best Practices

### Security
- ✅ All S3 buckets encrypted at rest
- ✅ Public access blocked on all buckets
- ✅ IAM roles follow least privilege principle
- ✅ VPC isolation for compute resources
- ✅ Security groups with minimal ingress rules

### High Availability
- ✅ Multi-AZ subnet deployment
- ✅ NAT Gateway for private subnet internet access
- ✅ S3 versioning enabled

### Cost Optimization
- ✅ Use appropriate instance types per environment
- ✅ ECR lifecycle policies to remove old images
- ✅ CloudWatch log retention policies
- ✅ On-demand vs reserved capacity planning

### Operational Excellence
- ✅ Infrastructure as Code (IaC)
- ✅ Modular design for reusability
- ✅ Environment separation
- ✅ Comprehensive monitoring and alerting

## Cost Optimization

### Estimated Monthly Costs (Development)

| Service | Estimated Cost |
|---------|---------------|
| VPC (NAT Gateway) | $32 |
| S3 Storage (100GB) | $2.30 |
| SageMaker Domain | $0 (pay per use) |
| Glue | Pay per job run |
| Lambda | Pay per invocation |
| CloudWatch | $5-10 |
| **Total** | **~$40-50/month** |

### Cost Reduction Tips

1. **Use Spot Instances** for SageMaker training
2. **Enable S3 Intelligent Tiering** for infrequently accessed data
3. **Set CloudWatch log retention** to 7-30 days for dev
4. **Use VPC Endpoints** instead of NAT Gateway where possible
5. **Clean up unused resources** regularly

## Troubleshooting

### Common Issues

**Issue**: Terraform state lock error
```bash
# Solution: Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

**Issue**: SageMaker Domain creation fails
- Ensure VPC has DNS support enabled
- Verify subnet has available IP addresses
- Check IAM role permissions

**Issue**: Lambda function timeout in VPC
- Verify NAT Gateway is configured
- Check security group egress rules
- Ensure route table has NAT Gateway route

### Cleanup

To destroy all resources:

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

⚠️ **Warning**: This will delete all resources including data in S3 buckets.

## Outputs

After deployment, you'll get:

```hcl
vpc_id                  = "vpc-xxxxx"
sagemaker_domain_id     = "d-xxxxx"
data_bucket_name        = "mlops-pipeline-dev-data-xxxxx"
model_bucket_name       = "mlops-pipeline-dev-models-xxxxx"
ecr_repository_url      = "xxxxx.dkr.ecr.ap-south-1.amazonaws.com/mlops-pipeline-dev"
```

## Next Steps

1. **Upload Training Data** to S3 data bucket
2. **Create Glue ETL Script** and upload to S3
3. **Build and Push Docker Image** to ECR
4. **Configure SageMaker Training Job** parameters
5. **Execute Step Functions** state machine
6. **Monitor Pipeline** via CloudWatch dashboard

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request




