# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.82.0"
    }
  }

  required_version = ">= 1.1.0"
}
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = "aazure-resorce-group-RTL"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "storageforlogicappv1"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "elastic"


  sku {
    tier = "WorkflowStandard"
    size = "WS1"
  }
}

resource "azurerm_logic_app_standard" "example" {
  name                       = "terraform-v1-logic-app01"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "outlook-connectionKey" = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjNFMDY0RDRFMkFDQkQ0MTM1NUJDRUYwMEQ5OEFENkMwMkJFQjg2REIiLCJ4NXQiOiJQZ1pOVGlyTDFCTlZ2TzhBMllyV3dDdnJodHMiLCJ0eXAiOiJKV1QifQ.eyJ0cyI6ImE5MTJlYzhlLTZiNjItNDE4YS05OThkLWM1MDMwZDQ2ZTJjNCIsImNzIjoibG9naWMtYXBpcy1jZW50cmFsaW5kaWEvb3V0bG9vay9kMzI2MDgyMGUxNmM0NjlmODIzNzdiYWQ3NGFiNjA0MyIsInYiOiItOTIyMzM3MjAzNjg1NDc3NTgwOCIsImVudmlkIjoiZmYwMmQ2NDBlY2FjMjc0MSIsImF1ZCI6Imh0dHBzOi8vZmYwMmQ2NDBlY2FjMjc0MS4xMS5jb21tb24ubG9naWMtY2VudHJhbGluZGlhLmF6dXJlLWFwaWh1Yi5uZXQvYXBpbS9vdXRsb29rL2QzMjYwODIwZTE2YzQ2OWY4MjM3N2JhZDc0YWI2MDQzIiwibWFuYWdlbWVudCI6Imh0dHBzOi8vbWFuYWdlbWVudC5sb2dpYy1jZW50cmFsaW5kaWEuYXp1cmUtYXBpaHViLm5ldC8iLCJuYmYiOjE2ODE5NzM0ODcsImV4cCI6MTY4MjU3ODI4NywiaWF0IjoxNjgxOTczNDg3LCJpc3MiOiJodHRwczovL2xvZ2ljLWFwaXMtY2VudHJhbGluZGlhLmF6dXJlLWFwaW0ubmV0LyJ9.jmgMUXm-LwOyU7hyQ6mS4jRsvta-BZuIRw66hGKJ_8B3-Vm1W2hBou96RgYZfFZqwAqOu-xLIBDR8H3Hm9iIe_lkSdUJ4jsGPwL8CNFzcTkdxUaBBbsNLhdJH1n0ROnWGk0fRTw93C2sqcMCqVOJSrdzvPBFojEYkpPX_linxe9HOCoYb3jqAWgiYASw2A_CafDSJ36v_6Ufy9m3y7Yf_wilULLnTK_oaPAhAVbporVtj3LouJ5Y13576Xy5rqpo9GGBTfnEOhkOLzhmDX1JHPbJejqZUdu9DAhOeXCvHdXfOEY9gullpVNUK1toUg6FG9MpSJTNbtpdrTNKawJgTw"
    "AzureBlob_connectionString" = "DefaultEndpointsProtocol=https;AccountName=vscodelogiccicda400;AccountKey=QIGyvCbouLE73wn+UXnumqLyZcpLf9qS82Prc4NXAOC6c5DxZLdI8jvk6hWhG7vpqSoeOIRTOLXE+ASt/vBY+Q==;EndpointSuffix=core.windows.net"
  }
  definition = jsonencode(file("${path.module}/workflow.json"))
}


