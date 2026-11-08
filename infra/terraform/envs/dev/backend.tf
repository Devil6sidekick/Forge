terraform {
  backend "s3" {
    bucket       = "forge-tfstate-182711179200"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-3"
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-3"
}