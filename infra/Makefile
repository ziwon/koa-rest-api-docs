SHELL := $(shell which bash)
THIS_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TF := $(shell command -v terraform 2> /dev/null)
STATE_DIR = .terraform
.SILENT: ;               # no need for @

PHONY: get-tools
get-tools: # Install tools for development: # make get-tools
	echo "Installing brew packages.."
	HOMEBREW_BUNDLE_NO_LOCK=1 brew bundle
	echo "Installing terrafrom.. "
ifdef TF
	mv "$(shell which terraform)" "$(shell which terraform)".bak
endif
	tfswitch -l

.check-env:
	if test "$(AWS_REGION)" = "" ; then echo "AWS_REGION not set"; exit 1; fi
	if test "$(AWS_PROFILE)" = "" ; then echo "AWS_PROFILE not set"; exit 1; fi

PHONY: aws-profile
ifeq (aws-profile,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
aws-profile: # Configure aws profile: # make aws-profile
	aws configure --profile=$(ARGS)

PHONY: init
ifeq (init,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
init: .check-env # Initialize s3 backend: # make init {project} {env}
	echo "For Debugging: TF_LOG=trace make init {project} {env}"
	$(eval PROJECT := $(shell echo $(ARGS) | cut -d ' ' -f1))
	$(eval ENV := $(shell echo $(ARGS) | cut -d ' ' -f2))
	scripts/init.sh $(PROJECT) $(ENV)

PHONY: tfvars
ifeq (tfvars,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
tfvars: # Create a tfvars file per environment: # VPC_ID=vpc-53a49e3b make tfvars {project} {env}
	$(eval PROJECT := $(shell echo $(ARGS) | cut -d ' ' -f1))
	$(eval ENV := $(shell echo $(ARGS) | cut -d ' ' -f2))
	scripts/tfvars.sh $(PROJECT) $(ENV)
	cat config/$(PROJECT).$(ENV).tfvars

PHONY: refresh
ifeq (refresh,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
refresh: .check-env # Refresh the state file with infrastructure: # make refresh {project} {env}
	$(eval PROJECT := $(shell echo $(ARGS) | cut -d ' ' -f1))
	$(eval ENV := $(shell echo $(ARGS) | cut -d ' ' -f2))
	terraform refresh -var-file=config/$(PROJECT).$(ENV).tfvars

PHONY: plan
ifeq (plan,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
plan: .check-env # Generate and show an execution plan: # make plan {project} {env}
	$(eval PROJECT := $(shell echo $(ARGS) | cut -d ' ' -f1))
	$(eval ENV := $(shell echo $(ARGS) | cut -d ' ' -f2))
	terraform plan -var-file=config/$(PROJECT).$(ENV).tfvars

PHONY: pull
pull: .check-env # Get remote state to local: # make pull
	rm -f ./$(STATE_DIR)/terraform.tfstate
	TF_LOG=trace terraform state pull > terraform.tfstate

PHONY: apply
ifeq (apply,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
apply: .check-env # Builds or changes infrastructure: # make apply {project} {env}
	$(eval PROJECT := $(shell echo $(ARGS) | cut -d ' ' -f1))
	$(eval ENV := $(shell echo $(ARGS) | cut -d ' ' -f2))
	terraform apply -var-file=config/$(PROJECT).$(ENV).tfvars

PHONY: destroy
ifeq (destroy,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
destroy: .check-env # Destroy Terraform-managed infrastructure: # make destroy {project} {env}
	$(eval PROJECT := $(shell echo $(ARGS) | cut -d ' ' -f1))
	$(eval ENV := $(shell echo $(ARGS) | cut -d ' ' -f2))
	terraform destroy -var-file=config/$(PROJECT).$(ENV).tfvars

PHONY: lint
ifeq (lint,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
lint: # Lint the Terraform files: # make lint {project} {env}
	$(eval PROJECT := $(shell echo $(ARGS) | cut -d ' ' -f1))
	$(eval ENV := $(shell echo $(ARGS) | cut -d ' ' -f2))
	scripts/tflint.sh $(PROJECT) $(ENV)

PHONY: clean
clean: # Clean the Terraform-generated files: # make clean
	rm -rf $(STATE_DIR)
	rm -rf terraform.tfstate.d
	rm -rf *.zip

PHONY: check-scripts
check-scripts: # Lint the schell scripts: # make check-scripts
	shellcheck scripts/*.sh

PHONY: help
help: # Show this help message: # make help
	echo "Usage: make [command] [args]"
	grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | sort | sed -e 's/: \([a-z\.\-][^ ]*\) #/: #/g' | awk 'BEGIN {FS = ": # "}; {printf "\t\033[36m%-32s\033[0m \033[33m%-45s\033[0m (e.g. \033[32m%s\033[0m)\n", $$1, $$2, $$3}'

.DEFAULT_GOAL := help
