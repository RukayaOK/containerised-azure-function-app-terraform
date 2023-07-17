#!/bin/bash

# Path 
export TERRAFORM_PATH=terraform
export APP_PATH=src

# Terraform Backend Bootstrap and Init 
export TERRAFORM_BACKEND_TENANT_ID=""
export TERRAFORM_BACKEND_SUBSCRIPTION_ID=""
export TERRAFORM_BACKEND_LOCATION=""
export TERRAFORM_BACKEND_RESOURCE_GROUP=""
export TERRAFORM_BACKEND_STORAGE_ACCOUNT=""
export TERRAFORM_BACKEND_STORAGE_ACCOUNT_SKU=""
export TERRAFORM_BACKEND_CONTAINER=""
export TERRAFORM_BACKEND_STATE_FILE=""
export TERRAFORM_SERVICE_PRINCIPAL=""

# Terraform Variables
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_TENANT_ID=""
export ARM_SUBSCRIPTION_ID=""
export ARM_ACCESS_KEY=""

# App variables 
export APP_NAME=""

# Docker variables
export IMAGE_TAG=""