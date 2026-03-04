terraform {
  backend "s3" {
    bucket = "marmil-project-terraform-state"
    key    = "marmil-project-terraform.tfstate"
    encrypt = true
    region = "us-east-1"
    use_lockfile = true
  }
}
