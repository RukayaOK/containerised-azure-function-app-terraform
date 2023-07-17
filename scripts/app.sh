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

# Logic
function get_terra_vars() {
    _information "Retrieving Azure Container Registry Server..."
    ACR_SERVER=`terraform -chdir=${TERRAFORM_PATH} output -raw acr_server`
    _success "Retrieved Azure Container Registry Server"

    _information "Retrieving Image Name..."
    IMAGE_NAME=`terraform -chdir=${TERRAFORM_PATH} output -raw image_name`
    _success "Retrieved Image Name"
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

    get_terra_vars

    _information "Changing to App Directory..."
    cd $APP_PATH
    _success "Changed to App Directory"

    if [[ -z "${ACR_SERVER}"  || -z "${IMAGE_NAME}" ]]
    then
        docker build -t funcappimage:${IMAGE_TAG} .
    else
        docker build -t ${ACR_SERVER}/${IMAGE_NAME}:${IMAGE_TAG} .
    fi
}


function deploy() {

    get_terra_vars
    
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
    az acr build --registry ${ACR_SERVER} --image ${ACR_SERVER}/${IMAGE_NAME}:${IMAGE_TAG} .
    _success "Pushed image to Azure Container Registry"

    _information "Logging out of Azure..."
    az logout || true
    _success "Logged out of Azure"
}

"$@"