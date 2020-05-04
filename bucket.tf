provider "aws" {
  profile = "default" 
  region  = "eu-west-3"
}

resource "aws_s3_bucket" "tf_bucket" {
  bucket = "s3-20200504" # unique name
  acl    = "private"
}