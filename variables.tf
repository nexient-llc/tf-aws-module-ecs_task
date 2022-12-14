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

variable "name" {
  description = "Application Name running in ECS Task"
  type        = string
}

variable "instance" {
  description = "The resource instance"
  type        = string
  default     = "000"
}

variable "cpu" {
  description = "Task CPU units to provision (1 vCPU = 1024 CPU units)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Task memory to provision (in MB)"
  type        = string
  default     = "512"
}

variable "container_definitions" {
  description = "The container definitions to drop in the task"
  type        = string
}

variable "network_mode" {
  description = "Set which network mode to use"
  type        = string
  default     = "awsvpc"

  validation {
    condition     = contains(["none", "awsvpc", "bridge", "host"], var.network_mode)
    error_message = "Check valid Docker networking modes here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#network_mode ."
  }
}

variable "requires_compatibilities" {
  description = "Set FARGATE or EC2 Requirement"
  type        = string
  default     = "FARGATE"

  validation {
    condition     = contains(["EC2", "FARGATE"], var.requires_compatibilities)
    error_message = "Check valid launch types here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#requires_compatibilities ."
  }
}

variable "log_group_name" {
  description = "Name of the log group to create for task logs"
  type        = string
}

variable "log_retention_days" {
  description = "Set how many days you wish to retain logs"
  type        = string
  default     = "7"
}

variable "kms_key_id" {
  description = "Optional: Set a KMS Key ID to encrypt logs"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to all resources created"
  type        = map(string)
  default     = {}
}
