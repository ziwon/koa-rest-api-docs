region = "{{ REGION }}"
vpc_id = "{{ VPC_ID }}"

project = "{{ PROJECT_NAME }}"
app = "{{ APP_NAME }}"
environment = "{{ ENV }}"

certificate_arn = "{{ CERTIFICATE_ARN }}"
kms_arn = "{{ KMS_ARN }}"

task_definition = {
	cpu = 256
	memory = 512
	container_name = "app"
	container_image = "{{ CONTAINER_IMAGE }}"
	container_port	= {{ CONTAINER_PORT }}
}

tags = {
	"Client" = "{{ CLIENT_NAME }}"
	"Terraform" = true
	"Environment" = "{{ ENV }}"
}
