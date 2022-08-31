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

###############################################################################
# Log Outputs
###############################################################################
output "log_group_name" {
  description = "The name of the cloudwatch log group where logs will be stored for the task"
  value       = var.log_group_name
}

output "log_group_arn" {
  description = "The ARN of the cloudwatch log group where logs will be stored for the task"
  value       = aws_cloudwatch_log_group.task_logs.arn
}

###############################################################################
# Task Outputs
###############################################################################
output "arn" {
  description = "Full arn of task"
  value       = aws_ecs_task_definition.task.arn
}

output "family" {
  description = "Task Family Name"
  value       = aws_ecs_task_definition.task.family
}

output "revision" {
  description = "Task Revision Number"
  value       = aws_ecs_task_definition.task.revision
}

output "role_id" {
  description = "Role ID of the Task Role to attach policies to"
  value       = aws_iam_role.ecs_task_role.id
}

output "role_arn" {
  description = "Role ARN of the Task Role to attach policies to"
  value       = aws_iam_role.ecs_task_role.arn
}

output "role_assume_id" {
  description = "Role ID of the Task Assume Role to attach policies to"
  value       = aws_iam_role.ecs_task_assume.id
}

output "role_assume_arn" {
  description = "Role ARN of the Task Assume Role to attach policies to"
  value       = aws_iam_role.ecs_task_assume.arn
}
