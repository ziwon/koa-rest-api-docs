# Infra


## Prerequisites

We assume that `AWS_REGION` and `AWS_PROFILE` will be used environment variables for the AWS configuration. We will utilize [`direnv`](https://github.com/direnv/direnv) to auto configure and source these environment variables on the current directory. Please update `.envrc` to your own `AWS_REGION` and `AWS_PROFILE`.

```sh
$ cat .envrc
export AWS_REGION="ap-northeast-2"
export AWS_PROFILE="ziwon"
```

Or you can create your own profile with `make aws-profile {profile}`

$ make aws-profile my_profile


## Makefile

All commands have pre-defined using makefile targets:

```
$ cd infra
$ make
Usage: make [command] [args]
        apply                            Builds or changes infrastructure              (e.g. make apply {project} {env})
        aws-profile                      Configure aws profile                         (e.g. make aws-profile)
        check-scripts                    Lint the schell scripts                       (e.g. make check-scripts)
        clean                            Clean the Terraform-generated files           (e.g. make clean)
        destroy                          Destroy Terraform-managed infrastructure      (e.g. make destroy {project} {env})
        get-tools                        Install tools for development                 (e.g. make get-tools)
        help                             Show this help message                        (e.g. make help)
        init                             Initialize s3 backend                         (e.g. make init {project} {env})
        lint                             Lint the Terraform files                      (e.g. make lint {project} {env})
        plan                             Generate and show an execution plan           (e.g. make plan {project} {env})
        pull                             Get remote state to local                     (e.g. make pull)
        refresh                          Refresh the state file with infrastructure    (e.g. make refresh {project} {env})
        tfvars                           Create a tfvars file per environment          (e.g. VPC_ID=vpc-53a49e3b make tfvars {project} {env})
```

You can also enable debugging mode with `DEBUG=1` for `make init`, `make tfvars`, and `make tflint`

```
$ DEBUG=1 make init ziwon dev
```


## Initialize a Project
We don't manage S3 backend and ECR registry as IaC manner. These base components before terraform provisioning are generated through `aws cli`.

For example, when you execute `make init {project} {dev}`, the following components will be created:

- s3: `tf-state-ziwon-rest-api`
- ecr: `ziwon-rest-api`

```
$ make init ziwon dev
For Debugging: TF_LOG=trace make init {project} {env}
Info> Creating backend_config file..
Info> Creating bucket..
Warn> bucket: [tf-state-ziwon-rest-api] already created.
Warb> ECR Repo: [1234567890ab.dkr.ecr.ap-northeast-2.amazonaws.com/ziwon-rest-api] alread created.
Initializing modules...

Initializing the backend...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.archive: version = "~> 1.3"
* provider.template: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Warn> workspace: [dev] already exist.
```

## Generate tfvars
Before genereating an execute plan or building/updating your infrasturecture, you should have to generate the input variables for Terraform configuration. For example, you should enter the value of `vpc_id` where this fargate application will be deployed to.

You can generate this input values using `make tfvars ziwon dev`:

### VPC_ID

```
$ VPC_ID=vpc-06d12abcdefg700001 make tfvars ziwon dev
```

```
$ VPC_ID=vpc-06d12abcdefg700001 make tfvars ziwon dev
Creating tfvars file..
region = "ap-northeast-2"
vpc_id = "vpc-06d12abcdefg700001"

project = "ziwon"
app = "rest-api"
environment = "dev"

certificate_arn = ""
kms_arn = ""

task_definition = {
        cpu = 256
        memory = 512
        container_name = "app"
        container_image = "1234567890ab.dkr.ecr.ap-northeast-2.amazonaws.com/ziwon-rest-api:latest"
        container_port  = 7071
}

tags = {
        "Client" = "ziwon"
        "Terraform" = true
        "Environment" = "dev"
}
```

### TAG


```
$ VPC_ID=vpc-06d12abcdefg700001 TAG=1.0.0 make tfvars ziwon dev
Creating tfvars file..
region = "ap-northeast-2"
vpc_id = "vpc-06d12abcdefg700001"

project = "ziwon"
app = "rest-api"
environment = "dev"

certificate_arn = ""
kms_arn = ""

task_definition = {
        cpu = 256
        memory = 512
        container_name = "app"
        container_image = "1234567890ab.dkr.ecr.ap-northeast-2.amazonaws.com/ziwon-rest-api:1.0.0"
        container_port  = 7071
}

tags = {
        "Client" = "ziwon"
        "Terraform" = true
        "Environment" = "dev"
}
```


## Generate an execution plan
You can generate the Terraform execution plan using:

```
$ make plan ziwon dev
```

## Builds or changes infrastructure
You can builds or chnages infrastructure with:

```
$ make apply ziwon dev
```

```
...
Apply complete! Resources: 5 added, 10 changed, 0 destroyed.

Outputs:

ecs_cluster_arn = arn:aws:ecs:ap-northeast-2:1234567890ab:cluster/ziwon-rest-api-dev
ecs_cluster_id = arn:aws:ecs:ap-northeast-2:1234567890ab:cluster/ziwon-rest-api-dev
http_tcp_listener_arns = [
  "arn:aws:elasticloadbalancing:ap-northeast-2:1234567890ab:listener/app/ziwon-rest-api-dev/96..........................cef",
]
http_tcp_listener_ids = [
  "arn:aws:elasticloadbalancing:ap-northeast-2:1234567890ab:listener/app/ziwon-rest-api-dev/96..........................cef",
]
https_listener_arns = []
https_listener_ids = []
main_lb_arn = arn:aws:elasticloadbalancing:ap-northeast-1:1234567890ab:loadbalancer/app/ziwon-rest-api-dev/96ee92...........
main_lb_dns_name = ziwon-rest-api-dev-111......ap-northeast-2.elb.amazonaws.com
main_lb_id = arn:aws:elasticloadbalancing:ap-northeast-1:1234567890ab:loadbalancer/app/ziwon-rest-api-dev/96ee92............
main_lb_zone_id = Z14GRHxxxxxxx
private_subnets = {
  "id" = "vpc-06d12abcdefg700001"
  "ids" = [
    "subnet-03c32fffffffffff0,
    "subnet-09a99fffffffffff1",
    "subnet-0fe0efffffffffff2",
  ]
  "tags" = {
    "Type" = "private"
  }
  "vpc_id" = "vpc-06d12abcdefg700001"
}
public_subnets = {
  "id" = "vpc-06d12abcdefg700001"
  "ids" = [
    "subnet-02c32fffffffffff0",
    "subnet-02c32fffffffffff1",
    "subnet-02c32fffffffffff2",
  ]
  "tags" = {
    "Type" = "public"
  }
  "vpc_id" = "vpc-06d12abcdefg700001"
}
target_group_arns = [
  "arn:aws:elasticloadbalancing:ap-northeast-2:1234567890ab:targetgroup/ziwon-rest-api-dev/6bd2cxxxxxxxxxxxx",
]
target_group_names = [
  "ziwon-rest-api-dev",
]
```

## Docker Image

- build: Use `make docker-build`
- push: Use `make docker-push`

You can update the ECR repository when building or pushing an image with `PROJECT_NAME`, `TAG`, and `AWS_REGION`:

```
AWS_ACCOUNT_ID=1234567890ab PROJECT_NAME=awesome-proj TAG=1.0.0 make docker-build
```

Other available commands are:

```
$ make
        Makefile:docker-build            Build docker image                            (e.g. make docker-build)
        Makefile:docker-commit           Commit current container using killed tag     (e.g. make docker-commit)
        Makefile:docker-history          Show the history of an image                  (e.g. make docker-history)
        Makefile:docker-login            Log in to an Amazon ECR registry              (e.g. make docker-login)
        Makefile:docker-push             Push an image to Amazon ECR registry          (e.g. make docker-push)
        Makefile:docker-run              Run a command in a new container              (e.g. make docker-run)
        manifests/Makefile:apply         Builds or changes infrastructure              (e.g. make apply {project} {env})
        manifests/Makefile:aws-profile   Configure aws profile                         (e.g. make aws-profile)
        manifests/Makefile:check-scripts Lint the schell scripts                       (e.g. make check-scripts)
        manifests/Makefile:clean         Clean the Terraform-generated files           (e.g. make clean)
        manifests/Makefile:destroy       Destroy Terraform-managed infrastructure      (e.g. make destroy {project} {env})
        manifests/Makefile:get-tools     Install tools for development                 (e.g. make get-tools)
        manifests/Makefile:help          Show this help message                        (e.g. make help)
        manifests/Makefile:init          Initialize s3 backend                         (e.g. make init {project} {env})
        manifests/Makefile:lint          Lint the Terraform files                      (e.g. make lint {project} {env})
        manifests/Makefile:plan          Generate and show an execution plan           (e.g. make plan {project} {env})
        manifests/Makefile:pull          Get remote state to local                     (e.g. make pull)
        manifests/Makefile:refresh       Refresh the state file with infrastructure    (e.g. make refresh {project} {env})
        manifests/Makefile:tfvars        Create a tfvars file per environment          (e.g. VPC_ID=vpc-53a49e3b make tfvars {project} {env})
```

## Future works
- Shipping logs to Elastic Search
- CI/CD with GitLab
