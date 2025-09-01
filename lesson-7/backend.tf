#Налаштування бекенду для стейтів ( S3 + DynamoDB )

terraform {
  backend "s3" {
    bucket = "alina-bucket-name-lesson-7"
    key            = "lesson-7/terraform.tfstate"
   region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
