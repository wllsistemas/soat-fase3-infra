terraform {
  backend "s3" {
    bucket  = "s3-fiap-soat-fase3"
    key     = "terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}