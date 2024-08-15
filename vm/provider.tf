terraform {
  required_version = ">=1.5.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.76"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.43"
    }
  }

  backend "local" {
    path = "work/envs/dev/dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}