terraform {
  backend "s3" {
    bucket = "alina-bucket-name-lesson-5"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
