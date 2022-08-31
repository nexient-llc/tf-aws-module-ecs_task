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
resource "aws_iam_role" "ecs_task_assume" {
  name = "${var.name}-ecs-task-assume-000"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com",
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecs-task-role-000"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}_ecs_task_role"
    },
  )

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com",
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "ecs_default_task_role" {
  name = "${var.name}-ecs-default-task-role-000"
  role = aws_iam_role.ecs_task_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "${aws_cloudwatch_log_group.task_logs.arn}"
        }
    ]
}
POLICY

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
