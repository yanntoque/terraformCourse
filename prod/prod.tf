variable "whitelist"{
  type = list(string)
}
variable "web_image_id"{
  type = string
}
variable "web_instance_type"{
  type = string
} 
variable "web_desired_capacity"{
  type = number
} 
variable "web_max_size"{
  type = number
}
variable "web_min_size"{
  type = number
}

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

/*default subnets on per availability zone */
resource "aws_default_subnet" "default_az1" {
  availability_zone = "eu-west-3a"
  tags = {
      "Terraform" = "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "eu-west-3b"
  tags = {
      "Terraform" = "true"
  }
}

resource "aws_security_group" "prod_web" {
  name        = "tf-prod-web"
  description = "Allows standard http and https ports inbound and everything outbound. This is for example purpose. In real case scenarii restrictions would be applied"
 
  ingress{
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.whitelist // for example purpose we allow everything in 
  }
  ingress{
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.whitelist // for example purpose we allow everything in 
  }

  // for example purpose allow all ports, all protocol, and all ip addresses
  egress{
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.whitelist
  }

  tags = {
      "Terraform" = "true"
  }
}
/*
For the example tutorial we only have one "env" which is "prod"
if we had multiple environment we would have created a directory per env
*/
module "web_app" {
  source = "./modules/webapp"
  
  web_image_id         = var.web_image_id
  web_instance_type    = var.web_instance_type
  web_desired_capacity = var.web_desired_capacity
  web_max_size         = var.web_max_size
  web_min_size         = var.web_min_size
  subnets              = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]
  security_groups      = [aws_security_group.prod_web.id]
  web_app              ="prod"
}
