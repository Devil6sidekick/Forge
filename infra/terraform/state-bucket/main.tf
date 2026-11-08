provider "aws" {
  region = "eu-west-3"
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "forge-tfstate-182711179200"
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}