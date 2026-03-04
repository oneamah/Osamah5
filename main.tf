terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.34.0"
    }
    helm = {
        source = "hashicorp/helm"
        version = "~> 3.1.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.37.0"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.12.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0.0"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.8.1"
    }
  }
  required_version = "~> 1.14.0"
}

provider "aws" {
  region = var.region
}
