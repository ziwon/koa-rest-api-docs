#!/bin/bash

# Enable debug mode with DEBUG=1
[ -z "$DEBUG" ] || set -x

MANIFESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" >/dev/null 2>&1 && pwd )"

AWS_REGION=${AWS_REGION:-ap-northeast-2}
AWS_ACCESS_KEY=$( grep "${AWS_PROFILE}" ~/.aws/credentials -A 2 | tail -n +2 | awk '/aws_access_key_id/{print $3}')
AWS_SECRET_KEY=$( grep "${AWS_PROFILE}" ~/.aws/credentials -A 2 | tail -n +2 | awk '/aws_secret_access_key/{print $3}')

PROJECT_NAME=$1
ENV=$2

TF_LINT_TPL=${MANIFESTS_DIR}/config/tflint.tpl
TF_LINT_NEW=${MANIFESTS_DIR}/config/$PROJECT_NAME.$ENV.tflint

echo "Creating tflint.hcl file.."
[ -f "$TF_LINT_NEW" ] && rm "$TF_LINT_NEW"

sed "s/{{ AWS_REGION }}/${AWS_REGION}/; \
	s/{{ AWS_ACCESS_KEY }}/${AWS_ACCESS_KEY}/; \
	s/{{ AWS_SECRET_KEY }}/${AWS_SECRET_KEY}/; \
	s/{{ TF_VARS_FILE }}/${PROJECT_NAME}.${ENV}.tfvars/;" \
	"$TF_LINT_TPL" > "$TF_LINT_NEW"

tflint --config "$TF_LINT_NEW"
