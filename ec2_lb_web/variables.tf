# variable "region" {
#   default = "eu-west-3"
# }

variable "names" {
  type = "map"
    default = {
      "vpc"  = "TerraformCPV"
      "somethingElse" = "testName"
  }
}


# Set up env

provider "aws" {
  profile   = "default"
  region    = "eu-west-3"
}

# Store available AZs in "available"

data "aws_availability_zones" "available" {
  state = "available"
}