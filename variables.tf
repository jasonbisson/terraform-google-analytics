/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "enable_apis" {
  description = "Whether to actually enable the APIs. If false, this module is a no-op."
  default     = "true"
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy"
  default     = "false"
  type        = string
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services"
  default     = "false"
  type        = string
}

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  default     = ["bigquery.googleapis.com", "iam.googleapis.com"]
  type        = list(string)
}

variable "constraints" {
  description = "The list of constraints to disable"
  default     = ["iam.allowedPolicyMemberDomains"]
  type        = list(string)
}

variable "ga360_service_account" {
  description = "The name of the GA360 service account"
  type        = string
  default     = "analytics-processing-dev@system.gserviceaccount.com"
}

variable "ga360_user" {
  description = "The name of the GA360 service account"
  type        = string
}

variable "sa_role_id" {
  type        = string
  description = "ID of the Custom Role."
  default     = "GA360EXPORT_SA"
}

variable "user_role_id" {
  type        = string
  description = "ID of the Custom Role."
  default     = "GA360EXPORT_USER"
}

variable "sa_title" {
  type        = string
  description = "Human-readable title of the Custom Role, defaults to role_id."
  default     = "GA360 Export Service Service Account"
}

variable "user_title" {
  type        = string
  description = "Human-readable title of the Custom Role, defaults to role_id."
  default     = "GA360 Export Service Human User"
}

variable "sa_permissions" {
  type        = list(string)
  description = "IAM permissions assigned to Custom Role."
  default     = ["bigquery.datasets.create", "bigquery.datasets.get", "bigquery.tables.create", "bigquery.tables.get", "bigquery.tables.delete", "bigquery.tables.updateData", "bigquery.jobs.create", "bigquery.jobs.list", "resourcemanager.projects.get"]
}

variable "user_permissions" {
  type        = list(string)
  description = "IAM permissions assigned to Custom Role."
  default     = ["resourcemanager.projects.get", "serviceusage.services.list","serviceusage.services.enable","resourcemanager.projects.setIamPolicy"]
}

variable "description" {
  type        = string
  description = "Description of Custom role."
  default     = "Google Analytics 360 Export Service Custom Role"
}

variable "stage" {
  type        = string
  description = "The current launch stage of the role. Defaults to GA."
  default     = "GA"
}
