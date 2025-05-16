terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"  # Replace with your bucket
    key            = "cats-app/terraform.tfstate"
    region         = "us-east-1"                  # Match your region
    dynamodb_table = "terraform-lock-table"       # DynamoDB table for locking
    encrypt        = true
  }
}
