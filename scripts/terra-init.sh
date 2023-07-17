#!/bin/bash

set -e

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source "${SCRIPT_DIR}"/./_helpers.sh

_information "Creating JSON file for Azure account details..."
export az_account_details="$HOME/.az_details.json"
touch "${az_account_details}"
_success "Created JSON file for Azure account details"

_information "Prompting Login to Azure..."
az login --tenant $TERRAFORM_BACKEND_TENANT_ID | grep -v "Opening in existing browser session.">  "${az_account_details}" 
_success "Logged into Azure" 

_information "Setting Azure Subscription ID..."
az account set -s $TERRAFORM_BACKEND_SUBSCRIPTION_ID
_success "Set Azure Subscription ID"

_information "Creating Resource Group..."
az group create \
    --location "${TERRAFORM_BACKEND_LOCATION}" \
    --name "${TERRAFORM_BACKEND_RESOURCE_GROUP}"
_success "Created Resource Group"

_information "Creating Storage Account..."
az storage account create \
    --name "${TERRAFORM_BACKEND_STORAGE_ACCOUNT}" \
    --resource-group "${TERRAFORM_BACKEND_RESOURCE_GROUP}" \
    --location "${TERRAFORM_BACKEND_LOCATION}" \
    --sku "${TERRAFORM_BACKEND_STORAGE_ACCOUNT_SKU}"
_success "Created Storage Account"

_information "Creating Storage Account Container..."
az storage container create \
--name "${TERRAFORM_BACKEND_CONTAINER}" \
--account-name "${TERRAFORM_BACKEND_STORAGE_ACCOUNT}"
_success "Created Storage Account Container"

_information "----------------"
_information "Storage Account Key:"
storage_account_key=$(az storage account keys list \
    --account-name "${TERRAFORM_BACKEND_STORAGE_ACCOUNT}" \
    --query "[0].value" \
    -o tsv)
_information "----------------"

_information "Creating Service Principal..."
created_service_principal=$(az ad sp create-for-rbac \
    --name "${TERRAFORM_SERVICE_PRINCIPAL}" \
    --role Owner \
    --scopes /subscriptions/"${TERRAFORM_BACKEND_SUBSCRIPTION_ID}")
created_app_id=$(echo $created_service_principal | jq -r '.appId')
created_password=$(echo $created_service_principal | jq -r '.password')
_success "Created Service Principal"

_information "----------------"
_information "For env.local.sh..."
echo "export ARM_CLIENT_ID=$created_app_id"
echo "export ARM_CLIENT_SECRET=$created_password"
echo "export ARM_TENANT_ID=$TERRAFORM_BACKEND_TENANT_ID"
echo "export ARM_SUBSCRIPTION_ID="
echo "export ARM_ACCESS_KEY=$storage_account_key"
_information "----------------"