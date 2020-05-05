provider "aws" {
  profile = "default"
  region   = "eu-west-3"
}

resource "aws_s3_bucket" "prod_bucket" {
  bucket = "tf-prod-20200505"
  acl    = "private"
}


/* Default vpc
as our code will use networking and compute features we define a vpc*/
resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "prod_web" {
  name        = "tf-prod-web"
  description = "Allows standard http and https ports inbound and everything outbound. This is for example purpose. In real case scenarii restrictions would be applied"
 
  ingress{
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] // for example purpose we allow everything in 
  }
  ingress{
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] // for example purpose we allow everything in 
  }

  // for example purpose allow all ports, all protocol, and all ip addresses
  egress{
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      "Terraform" = "true"
  }
}
