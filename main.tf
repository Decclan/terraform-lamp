#aws provider
provider "aws" {
  #access_key = var.access_key
  #secret_key = var.secret_key
  region     = var.region
}
#get AZ's details
data "aws_availability_zones" "availability_zones" {}

