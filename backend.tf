terraform {
  backend "s3" {
    bucket       = "chinonny251-cloud-accelerator-state"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true

  }
}

