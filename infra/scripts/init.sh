#!/bin/bash

# Enable debug mode with DEBUG=1
[ -z "$DEBUG" ] || set -x

MANIFESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" >/dev/null 2>&1 && pwd )"

CONFIG_HCL=${MANIFESTS_DIR}/config/backend_config.hcl
CONFIG_TPL=${MANIFESTS_DIR}/config/backend_config.tpl

AWS_REGION=${AWS_REGION:-ap-northeast-2}
APP_NAME=${APP_NAME:-rest-api}

PROJECT_NAME=$1
ENV=$2


info() {
  tput setaf 4; echo "Info> $*" && tput sgr0
}

warn() {
  tput setaf 3; echo "Warn> $*" && tput sgr0
}

err() {
  tput setaf 1; echo "Error> $*" && tput sgr0
  exit 1
}


# http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
has_credentials() {
	if ! grep -q aws_access_key_id ~/.aws/config; then
		if ! grep -q aws_access_key_id ~/.aws/credentials; then
			err "AWS config not found or CLI not installed. Please run \"aws configure\"."
		fi
	fi
}

create_config() {
	local project_name=$1
	info "Creating backend_config file.."
	[ -f "$CONFIG_HCL" ] && rm "$CONFIG_HCL"
		sed "s/{{ PROJECT }}/${project_name}/;\
		s/{{ REGION }}/${AWS_REGION}/;" \
		"$CONFIG_TPL" > "$CONFIG_HCL"
}

get_config() {
	if [ ! -f "$CONFIG_HCL" ]; then
		err "backend_config.hcl not exist."
	fi
	awk -F '=' '/'"$1"'/{print $2}' "$CONFIG_HCL" |  tr -d '"' | tr -d ' '
}

create_bucket() {
	info "Creating bucket.."
	bucket_name=$(get_config 'bucket')
	count=$(aws s3 ls | grep -c "$bucket_name")
	if [ "$count" -eq 1 ]; then
		warn "bucket: [$bucket_name] already created."
	else
		aws s3api create-bucket \
			--bucket "$bucket_name" \
			--region "$AWS_REGION" \
			--create-bucket-configuration LocationConstraint="$AWS_REGION"
	fi
}

delete_bucket() {
	info "Deleting bucket.."
	bucket_name=$(get_config 'bucket')
	count=$(aws s3 ls | grep -c "$bucket_name")
	if [ "$count" -eq 0 ]; then
		warn "bucket: [$bucket_name] not exist."
	else
		aws s3api delete-bucket --bucket "$bucket_name" --region "$AWS_REGION"
	fi
}

create_ecr() {
	aws ecr describe-repositories --repository-names "${PROJECT_NAME}-${APP_NAME}" >/dev/null 2>&1 \
		|| aws ecr create-repository --repository-name "${PROJECT_NAME}-${APP_NAME}"
	info "ECR Repo:" "$(aws ecr describe-repositories --repository-names "${PROJECT_NAME}-${APP_NAME}" | jq -r '.repositories[0].repositoryUri')"
}

init_backend() {
	terraform init -backend-config="$CONFIG_HCL"
}

set_workspace() {
	count=$(terraform workspace list | grep -c "$1")
	if [ "$count"  == 0 ]; then
		terraform workspace new "$1"
	else
		warn "workspace: [$1] already exist."
	fi
}

if has_credentials; then
	create_config "$PROJECT_NAME" "$ENV"
	create_bucket
	create_ecr
	init_backend
	set_workspace "$ENV"
fi
