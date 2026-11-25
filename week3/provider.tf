terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAR5U3LRGGHBHKRNEV"
  secret_key = "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"
}
