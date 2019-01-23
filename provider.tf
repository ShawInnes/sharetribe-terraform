provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "sharetribe-terraform"
    key    = "network/terraform.tfstate"
    region = "ap-southeast-2"
  }
}
