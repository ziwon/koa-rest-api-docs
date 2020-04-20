# Update this to your AWS_ACCOUNT_ID
AWS_ACCOUNT_ID ?= 1234567890ab
AWS_REGION ?= ap-northeast-2

PROJECT_NAME ?= ziwon
APP_NAME ?= rest-api
TAG ?= latest

ECR_IMAGE_URL = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT_NAME)-$(APP_NAME)

include infra/Makefile

PHONY: docker-login
docker-login: # Log in to an Amazon ECR registry: # make docker-login
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_IMAGE_URL)

PHONY: docker-build
ifeq (docker-build,$(firstword $(MAKECMDGOALS)))
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(ARGS):;@:)
endif
docker-build: # Build docker image: # make docker-build
	docker build --force-rm -t $(PROJECT_NAME)-$(APP_NAME) \
		--build-arg DEBUG=$(ARGS) \
		--build-arg NPM_TOKEN=${NPM_TOKEN} .
	docker tag $(PROJECT_NAME)-$(APP_NAME):$(TAG) $(ECR_IMAGE_URL):$(TAG)

PHONY: docker-history
docker-history: # Show the history of an image: # make docker-history
	docker history --human --format "{{.CreatedBy}}: {{.Size}}" $(PROJECT_NAME)-$(APP_NAME)

PHONY: docker-commit
docker-commit: # Commit current container using killed tag: # make docker-commit
	docker commit $(shell docker inspect --format="{{.Id}}" $(PROJECT_NAME)-$(APP_NAME)) $(PROJECT_NAME)-$(APP_NAME):killed

PHONY: docker-run
docker-run: # Run a command in a new container: # make docker-run
ifeq ("$(wildcard .env)","")
	echo "Creating .env from .env.example..."
	cp .env.example .env
endif
	docker run --rm -it --env-file=.env --name $(APP_NAME) -p 80:7071 $(PROJECT_NAME)-$(APP_NAME)

PHONY: docker-push
docker-push: docker-login # Push an image to Amazon ECR registry: # make docker-push
	docker push $(ECR_IMAGE_URL):$(TAG)
