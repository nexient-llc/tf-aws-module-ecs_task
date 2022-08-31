# `tf-aws-module-ecs_task`

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This modules is used to setup a ECS Task

## Usage

```golang
module "task" {
  source = "../../modules/ecs/task"

  name                     = 'application'
  cpu                      = '256'
  memory                   = '512'
  log_group_name           = var.log_group_name
  log_retention_days       = 7
  task_definition          =
  network_mode             = "awsvpc"
  requires_compatibilities = "FARGATE"
  tags                     = var.tags
}
```

## Inputs

| Name                     | Description                                           |  Type  |     Default      | Required |
| ------------------------ | ----------------------------------------------------- | :----: | :--------------: | :------: |
| name                     | Application Name                                      | string |       n/a        |   yes    |
| cpu                      | Task CPU units to provision (1 vCPU = 1024 CPU units) | string |      `256`       |   yes    |
| memory                   | Task memory to provision (in MB)                      | string |      `512`       |   yes    |
| log_group_name           | Name of the log group to create for task logs         | string |       n/a        |   yes    |
| log_retention_days       | Set how many days you wish to retain logs             | string |       `7`        |   yes    |
| task_definition          | Task Definition to create                             | string | `json as string` |   yes    |
| network_mode             | Set which network mode to use                         | string |    `FARGATE`     |   yes    |
| requires_compatibilities | Set FARGATE or EC2 Requirement                        | string |       n/a        |   yes    |
| kms_key_id               | Optional: Set a KMS Key ID to encrypt logs            | string |       n/a        |    no    |
| tags                     | Tags to be applied to all resources created           |  map   |     `<map>`      |    no    |

## Outputs

| Name            | Description                                                                 |
| --------------- | --------------------------------------------------------------------------- |
| log_group_name  | The name of the cloudwatch log group where logs will be stored for the task |
| log_group_arn   | The ARN of the cloudwatch log group where logs will be stored for the task  |
| arn             | Full arn of task                                                            |
| family          | Task Family Name                                                            |
| revision        | Task Revision Number                                                        |
| role_id         | Role ID of the Task Role to attach policies to                              |
| role_arn        | Role ARN of the Task Role to attach policies to                             |
| role_assume_id  | Role ID of the Task Assume Role to attach policies to                       |
| role_assume_arn | Role ARN of the Task Assume Role to attach policies to                      |
