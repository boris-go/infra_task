terraform {
  # Using local state for simplicity
  # For production, use a remote backend - S3 with DynamoDB locking
  backend "local" {
    path = "terraform.tfstate"
  }

  # Uncomment for S3 backend in production
  #   backend "s3" {
  #     bucket         = "my-terraform-state-bucket"
  #     key            = "nginx-demo/terraform.tfstate"
  #     region         = "eu-north-1"
  #     encrypt        = true
  #     dynamodb_table = "terraform-lock"
  #   }
}
