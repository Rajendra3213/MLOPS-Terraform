terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "awscloudclub-terraform-s3-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}