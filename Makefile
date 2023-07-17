# Coloured Text 
red:=$(shell tput setaf 1)
yellow:=$(shell tput setaf 3)
reset:=$(shell tput sgr0)

# Set the Terraform Variables
TERRAFORM_BOOTSTRAP_VARS := TERRAFORM_BACKEND_SUBSCRIPTION_ID TERRAFORM_BACKEND_LOCATION TERRAFORM_BACKEND_RESOURCE_GROUP TERRAFORM_BACKEND_STORAGE_ACCOUNT TERRAFORM_BACKEND_STORAGE_ACCOUNT_SKU TERRAFORM_BACKEND_CONTAINER TERRAFORM_BACKEND_STATE_FILE TERRAFORM_SERVICE_PRINCIPAL
TERRAFORM_VARS_PATH=vars.tfvars
TERRAFORM_VARS := TERRAFORM_PATH ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_TENANT_ID ARM_SUBSCRIPTION_ID

# Set App Variables
APP_BOOTSTRAP_VARS := APP_NAME APP_PATH
APP_VARS := IMAGE_TAG

.PHONY: help
help:					## Displays the help
	@printf "\nUsage : make <command> \n\nThe following commands are available: \n\n"
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@printf "\n"

terra-bootstrap-env:		## Check Terraform Bootstrap Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(TERRAFORM_BOOTSTRAP_VARS),$(if $($v),$(info Variable $v defined),$(error Error: $v undefined)))
endif

.PHONY: terra-bootstrap
terra-bootstrap: terra-bootstrap-env	## Bootstrap Terraform
	sh ./scripts/terra-init.sh

terra-env:		## Check Terraform Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(TERRAFORM_VARS),$(if $($v),$(info Variable $v defined),$(error Error: $v undefined)))
endif

.PHONY: terra-init
terra-init: terra-env			## Initialises Terraform
	export ARM_SUBSCRIPTION_ID="${TERRAFORM_BACKEND_SUBSCRIPTION_ID}"
	terraform -chdir="${TERRAFORM_PATH}" init \
		-backend-config="storage_account_name=${TERRAFORM_BACKEND_STORAGE_ACCOUNT}" \
		-backend-config="container_name=${TERRAFORM_BACKEND_CONTAINER}" \
		-backend-config="key=${TERRAFORM_BACKEND_STATE_FILE}" \
		-backend-config="resource_group_name=${TERRAFORM_BACKEND_RESOURCE_GROUP}" 
	terraform -chdir=$(TERRAFORM_PATH) fmt --recursive

.PHONY: terra-plan
terra-plan: terra-init			## Plans Terraform
	export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
	terraform -chdir=$(TERRAFORM_PATH) validate
	terraform -chdir=$(TERRAFORM_PATH) plan -out=plan/tfplan.binary -var-file ${TERRAFORM_VARS_PATH}

.PHONY: terra-apply
terra-apply: terra-plan			## Applies Terraform
	export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
	terraform -chdir=$(TERRAFORM_PATH) apply plan/tfplan.binary

.PHONY: terra-destroy
terra-destroy: terra-init		## Destroy Terraform
	export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
	terraform -chdir=$(TERRAFORM_PATH) destroy -var-file ${TERRAFORM_VARS_PATH} -auto-approve

.PHONY: terra-list
terra-list: 			## List Terraform State
	export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
	terraform -chdir=$(TERRAFORM_PATH) state list

app-boostrap-env:			## Check App Bootstrap Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(APP_BOOTSTRAP_VARS),$(if $($v),,$(error Error: $v undefined)))
endif

.PHONY: app-bootstrap
app-bootstrap: app-boostrap-env		## Bootstrap Application
	sh ./scripts/app.sh init
	
app-env:			## Check App Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(APP_VARS),$(if $($v),,$(error Error: $v undefined)))
endif

.PHONY: app-build
app-build: app-env		## Build Application
	sh ./scripts/app.sh build

.PHONY: app-deploy
app-deploy: app-env		## Deploy Application
	sh ./scripts/app.sh deploy