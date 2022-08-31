// Copyright 2022 Nexient LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_caller_identity" "current" {}

###############################################################################
# IAM
###############################################################################

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

resource "aws_iam_role" "ecs_task_assume" {
  name = "${var.name}-ecs-task-assume-${var.instance}"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecs-task-role-${var.instance}"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}_ecs_task_role"
    },
  )

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

data "aws_iam_policy_document" "ecs_default_task_role" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.task_logs.arn}",
    ]
  }

}

resource "aws_iam_role_policy" "ecs_default_task_role" {
  name = "${var.name}-ecs-default-task-role-${var.instance}"
  role = aws_iam_role.ecs_task_role.id

  policy = data.aws_iam_policy_document.ecs_default_task_role.json

}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ecs_task_assume.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###############################################################################
# Task Logs
###############################################################################

resource "aws_cloudwatch_log_group" "task_logs" {
  name = var.log_group_name

  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = var.log_group_name
    },
  )
}

###############################################################################
# ECS Service/Task
###############################################################################

resource "aws_ecs_task_definition" "task" {
  family                   = var.name
  network_mode             = var.network_mode
  requires_compatibilities = [var.requires_compatibilities]
  execution_role_arn       = aws_iam_role.ecs_task_assume.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = var.task_definition
  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )
}
