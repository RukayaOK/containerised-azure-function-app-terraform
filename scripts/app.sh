#!/bin/bash

set -e

# Helpers
wipe="\033[1m\033[0m"

_information() {
    _color='\033[0;35m' #cyan
    echo "${_color} $1 ${wipe}"
}

_success() {
    _color='\033[0;32m' #green
    echo "${_color} $1 ${wipe}"
}

function init() {
   _information "Changing to App Directory..."
    cd $APP_PATH
    _success "Changed to App Directory"

    _information "Creating Virtual Environment..."
    python3 -m venv .venv
    _success "Created Virtual Environment"

    _information "Activating Virtual Environment..."
    source .venv/bin/activate
    _success "Activated Virtual Environment"

    _information "Initialising Function App..."
    func init --worker-runtime python --docker
    _success "Initialised Function App"

    _information "Creating Function App..."
    func new --name $APP_NAME --template "Timer trigger"
    _success "Created Function App"
}


function build() {

    _information "Changing to App Directory..."
    cd $APP_PATH
    _success "Changed to App Directory"

    _information "Building Docker Image..."
    docker build -t "${TF_VAR_ACR_NAME}".azurecr.io/"${TF_VAR_IMAGE_NAME}":"${IMAGE_TAG}" .
    _success "Built Docker Image"
}


function deploy() {
    
    _information "Logging into Azure..."
    az login \
        --service-principal \
        --username=${ARM_CLIENT_ID} \
        --password=${ARM_CLIENT_SECRET} \
        --tenant ${ARM_TENANT_ID}
    _success "Logged into Azure"

    _information "Setting Azure Subscription ID..."
    az account set -s ${ARM_SUBSCRIPTION_ID}
    _success "Set Azure Subscription ID"

    _information "Changing to App Directory..."
    cd $APP_PATH
    _success "Changed to App Directory"

    _information "Pushing image to Azure Container Registry..."
    az acr build \
        --registry "${TF_VAR_ACR_NAME}".azurecr.io \
        --image "${TF_VAR_ACR_NAME}".azurecr.io/${TF_VAR_IMAGE_NAME}:${IMAGE_TAG} .
    _success "Pushed image to Azure Container Registry"

    _information "Logging out of Azure..."
    az logout || true
    _success "Logged out of Azure"
}

"$@"