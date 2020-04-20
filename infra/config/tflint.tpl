config {
	module = true
	deep_check = true
	force = false

	aws_credentials = {
		access_key = "{{ AWS_ACCESS_KEY }}"
		secret_key = "{{ AWS_SECRET_KEY }}"
		region     = "{{ AWS_REGION }}"
	}

	ignore_module = {
		"./modules/global" = true
	}

	varfile = ["./config/{{ TF_VARS_FILE }}"]
}

rule "aws_instance_invalid_type" {
	enabled = false
}

rule "aws_instance_previous_type" {
	enabled = false
}
